# NOTE: Whenever you updated this version check if the `cacert` package also
#       needs an update. You can run the regular updater script for cacerts.
#       It will rebuild itself using the version of this package (NSS) and if
#       an update is required do the required changes to the expression.
#       Example: nix-shell ./maintainers/scripts/update.nix --argstr package cacert

import ./generic.nix {
  version = "3.129";
  hash = "sha256-cy7+nCVtogr1onk8/8OQcQZUm2AH2azNsUmVFg4ym7k=";
  filename = "latest.nix";
  versionRegex = "NSS_(\\d+)_(\\d+)(?:_(\\d+))?_RTM";
}
