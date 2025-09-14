let
  excluded =
    (builtins.fromJSON (builtins.readFile ./configuration-hackage2nix/excluded.json)).excluded-packages;
in
args@{
  pkgs,
  lib,
  callPackage,
}:
self:
(import ./hackage-packages.nix args self)
// lib.genAttrs excluded (name: {
  type = "error";
  meta = throw "The hackage package '${name}' was excluded from the hackage2nix configuration. Remove the exclusion and regenerate the package set to use it.";
})
