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
, url ? null
}:

genericUpdater {
  inherit pname version attrPath ignoredVersions rev-prefix odd-unstable patchlevel-unstable;
  versionLister = "${common-updater-scripts}/bin/list-archive-two-levels-versions ${lib.optionalString (url != null) "--url=${url}"}";
}
