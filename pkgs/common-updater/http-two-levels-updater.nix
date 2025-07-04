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
  rev-suffix ? "",
  odd-unstable ? false,
  patchlevel-unstable ? false,
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
    rev-suffix
    odd-unstable
    patchlevel-unstable
    ;
  versionLister = "${common-updater-scripts}/bin/list-archive-two-levels-versions ${
    lib.optionalString (url != null) "--url=${lib.escapeShellArg url}"
  }";
}
