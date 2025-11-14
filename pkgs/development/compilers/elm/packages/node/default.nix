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
  inherit (nodePkgs)
    elm-git-install
    ;

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

  elm-graphql = nodePkgs."@dillonkearns/elm-graphql" // {
    meta =
      with lib;
      nodePkgs."@dillonkearns/elm-graphql".meta
      // {
        description = "Autogenerate type-safe GraphQL queries in Elm";
        license = licenses.bsd3;
        maintainers = [ maintainers.pedrohlc ];
      };
  };

  elm-optimize-level-2 = nodePkgs."elm-optimize-level-2" // {
    meta =
      with lib;
      nodePkgs."elm-optimize-level-2".meta
      // {
        description = "Second level of optimization for the Javascript that the Elm Compiler produces";
        homepage = "https://github.com/mdgriffith/elm-optimize-level-2";
        license = licenses.bsd3;
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
