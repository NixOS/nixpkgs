{
  lib,
  genericUpdater,
  common-updater-scripts,
}:

{
  pname ? null,
  version ? null,
  attrPath ? null,
  allowedVersions ? "",
  ignoredVersions ? "",
  rev-prefix ? "",
  odd-unstable ? false,
  patchlevel-unstable ? false,
  # an explicit url is needed when src.meta.homepage or src.url don't
  # point to a git repo (eg. when using fetchurl, fetchzip, ...)
  url ? null,
}:

genericUpdater {
  inherit
    pname
    version
    attrPath
    allowedVersions
    ignoredVersions
    rev-prefix
    odd-unstable
    patchlevel-unstable
    ;
  versionLister = "${common-updater-scripts}/bin/list-git-tags ${
    lib.optionalString (url != null) "--url=${url}"
  }";
}
