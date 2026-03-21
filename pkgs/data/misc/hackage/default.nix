# Hackage database snapshot, used by maintainers/scripts/regenerate-hackage-packages.sh
# and callHackage
{ lib, fetchurl }:
let
  pin = lib.importJSON ./pin.json;
in
fetchurl (finalAttrs: {
  inherit (pin) url sha256;
  name = "${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
  pname = "all-cabal-hashes";
  version = lib.substring 0 7 pin.commit;
  passthru.updateScript = ../../../../maintainers/scripts/haskell/update-hackage.sh;
})
