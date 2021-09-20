# Hackage database snapshot, used by maintainers/scripts/regenerate-hackage-packages.sh
# and callHackage
{ fetchurl, runCommand, all-cabal-hashes }:
let
  pin = builtins.fromJSON (builtins.readFile ./pin.json);
in
fetchurl {
  inherit (pin) url sha256;
  passthru = {
    updateScript = ../../../../maintainers/scripts/haskell/update-hackage.sh;
    unpacked = runCommand "unpacked-cabal-hashes" {} ''
      tar xf ${all-cabal-hashes} --strip-components=1 --one-top-level=$out
    '';
  };
}
