# Hackage database snapshot, used by maintainers/scripts/regenerate-hackage-packages.sh
{ fetchFromGitHub }:
let
  pin = builtins.fromJSON (builtins.readFile ./pin.json);
in
  fetchFromGitHub (pin // { passthru.commit = pin.rev; })
