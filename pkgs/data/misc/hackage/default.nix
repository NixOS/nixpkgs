# Hackage database snapshot, used by maintainers/scripts/regenerate-hackage-packages.sh
# and callHackage
{ lib, fetchurl }:
let
  pin = lib.importJSON ./pin.json;
in
fetchurl {
  inherit (pin) url sha256;
  name = "all-cabal-hashes-${lib.substring 0 7 pin.commit}.tar.gz";
  passthru.updateScript = ../../../../maintainers/scripts/haskell/update-hackage.sh;
}
