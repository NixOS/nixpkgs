{ lib
, genericUpdater
, common-updater-scripts
}:

{ pname
, version
, attrPath ? pname
, ignoredVersions ? ""
, rev-prefix ? ""
, odd-unstable ? false
, patchlevel-unstable ? false
# explicit url is useful when git protocol is used only for tags listing
# while actual release is referred by tarball
, url ? null
}:

genericUpdater {
  inherit pname version attrPath ignoredVersions rev-prefix odd-unstable patchlevel-unstable;
  versionLister = "${common-updater-scripts}/bin/list-git-tags ${lib.optionalString (url != null) "--url=${url}"}";
}
