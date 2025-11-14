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
with self;
with elmLib;
{
  create-elm-app = patchNpmElm nodePkgs.create-elm-app // {
    meta =
      with lib;
      nodePkgs.create-elm-app.meta
      // {
        description = "Create Elm apps with no build configuration";
        homepage = "https://github.com/halfzebra/create-elm-app";
        license = licenses.mit;
        maintainers = [ maintainers.turbomack ];
      };
  };

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
