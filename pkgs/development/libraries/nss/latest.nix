# NOTE: Whenever you updated this version check if the `cacert` package also
#       needs an update. You can run the regular updater script for cacerts.
#       It will rebuild itself using the version of this package (NSS) and if
#       an update is required do the required changes to the expression.
#       Example: nix-shell ./maintainers/scripts/update.nix --argstr package cacert

import ./generic.nix {
  version = "3.112.3";
  hash = "sha256-1gOfP3HM1irGuJ+ln6n1toJC46+K5Z7pGm26vSryU7M=";
  filename = "latest.nix";
  versionRegex = "NSS_(\\d+)_(\\d+)(?:_(\\d+))?_RTM";
}
