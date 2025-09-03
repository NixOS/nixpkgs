# NOTE: Whenever you updated this version check if the `cacert` package also
#       needs an update. You can run the regular updater script for cacerts.
#       It will rebuild itself using the version of this package (NSS) and if
#       an update is required do the required changes to the expression.
#       Example: nix-shell ./maintainers/scripts/update.nix --argstr package cacert

import ./generic.nix {
  version = "3.115.1";
  hash = "sha256-SuXNqRW0lBPioYxmoGa3ZbfxC7ud6TW3xVpakVwtm14=";
  filename = "latest.nix";
  versionRegex = "NSS_(\\d+)_(\\d+)(?:_(\\d+))?_RTM";
}
