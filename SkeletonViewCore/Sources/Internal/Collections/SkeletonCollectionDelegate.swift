//
//  SkeletonCollectionDelegate.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 30/03/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

class SkeletonCollectionDelegate: NSObject {
    
    weak var originalTableViewDelegate: SkeletonTableViewDelegate?
    weak var originalCollectionViewDelegate: SkeletonCollectionViewDelegate?
    
    init(
        tableViewDelegate: SkeletonTableViewDelegate? = nil,
        collectionViewDelegate: SkeletonCollectionViewDelegate? = nil
    ) {
        self.originalTableViewDelegate = tableViewDelegate
        self.originalCollectionViewDelegate = collectionViewDelegate
    }
    
}

// MARK: - UITableViewDelegate
extension SkeletonCollectionDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerOrFooterView(tableView, for: originalTableViewDelegate?.collectionSkeletonView(tableView, identifierForHeaderInSection: section))
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        headerOrFooterView(tableView, for: originalTableViewDelegate?.collectionSkeletonView(tableView, identifierForFooterInSection: section))
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        view.hideSkeleton()
        originalTableViewDelegate?.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        view.hideSkeleton()
        originalTableViewDelegate?.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.hideSkeleton()
        originalTableViewDelegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegate
extension SkeletonCollectionDelegate: UICollectionViewDelegate { }

@MainActor
private extension SkeletonCollectionDelegate {
    
    func skeletonizeViewIfContainerSkeletonIsActive(container: UIView, view: UIView) {
        guard container.sk.isSkeletonActive,
              let skeletonConfig = container._currentSkeletonConfig
        else {
            return
        }

        view.showSkeleton(
            skeletonConfig: skeletonConfig,
            notifyDelegate: false
        )
    }
    
    func headerOrFooterView(_ tableView: UITableView, for viewIdentifier: String? ) -> UIView? {
        guard let viewIdentifier = viewIdentifier,
              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewIdentifier)
        else {
            return nil
        }
        
        skeletonizeViewIfContainerSkeletonIsActive(
            container: tableView,
            view: header
        )
        
        return header
    }
    
}
