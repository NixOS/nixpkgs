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
  url ? null,
  extraRegex ? null,
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
  versionLister = "${common-updater-scripts}/bin/list-directory-versions ${
    lib.optionalString (url != null) "--url=${lib.escapeShellArg url}"
  } ${lib.optionalString (extraRegex != null) "--extra-regex=${lib.escapeShellArg extraRegex}"}";
}
