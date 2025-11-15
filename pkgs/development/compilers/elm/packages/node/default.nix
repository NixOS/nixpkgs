{
  pkgs,
  lib,
  nodejs,
  makeWrapper,
}:
self:

let
  # Untouched npm-downloaded packages
  nodePkgs = pkgs.callPackage ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (pkgs.stdenv.hostPlatform) system;
  };
in
{
  elm-pages = import ./elm-pages {
    inherit
      nodePkgs
      pkgs
      lib
      makeWrapper
      ;
  };

  elm-land = pkgs.elm-land; # Alias
}
