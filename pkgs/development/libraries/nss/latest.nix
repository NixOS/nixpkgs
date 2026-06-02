# NOTE: Whenever you updated this version check if the `cacert` package also
#       needs an update. You can run the regular updater script for cacerts.
#       It will rebuild itself using the version of this package (NSS) and if
#       an update is required do the required changes to the expression.
#       Example: nix-shell ./maintainers/scripts/update.nix --argstr package cacert

import ./generic.nix {
  version = "3.124";
  hash = "sha256-bMUMyb/4qkiucbkvzSY5aNS3nfaJ4XWyqf2lKnVmXfU=";
  filename = "latest.nix";
  versionRegex = "NSS_(\\d+)_(\\d+)(?:_(\\d+))?_RTM";
}
