{ genericUpdater
, common-updater-scripts
}:

{ pname
, version
, attrPath ? pname
, ignoredVersions ? ""
, rev-prefix ? ""
, odd-unstable ? false
, patchlevel-unstable ? false
}:

genericUpdater {
  inherit pname version attrPath ignoredVersions rev-prefix odd-unstable patchlevel-unstable;
  versionLister = "${common-updater-scripts}/bin/list-git-tags";
}
