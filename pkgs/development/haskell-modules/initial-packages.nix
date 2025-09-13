args@{
  pkgs,
  lib,
  callPackage,
}:
self:
(import ./hackage-packages.nix args self)
// lib.genAttrs (lib.importJSON ./configuration-hackage2nix/excluded.json).excluded-packages (
  name:
  if pkgs.config.allowAliases then
    throw "The hackage package '${name}' was excluded from the hackage2nix configuration. Remove the exclusion and regenerate the package set to use it."
  else
    null
)
