{ callPackage, lib }:

{
  wallpapers = lib.recurseIntoAttrs (callPackage ./wallpapers.nix { });
}
