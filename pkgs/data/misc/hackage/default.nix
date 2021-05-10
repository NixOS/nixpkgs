# Hackage database snapshot, used by maintainers/scripts/regenerate-hackage-packages.sh
# and callHackage
{ fetchurl }:
let
  pin = builtins.fromJSON (builtins.readFile ./pin.json);
in
fetchurl {
  inherit (pin) url sha256;
  passthru.updateScript = ../../../../maintainers/scripts/haskell/update-hackage.sh;
}
