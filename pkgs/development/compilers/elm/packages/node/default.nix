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
    elm-live
    elm-upgrade
    elm-xref
    elm-analyse
    elm-git-install
    ;

  elm-verify-examples = nodePkgs.elm-verify-examples // {
    meta =
      with lib;
      nodePkgs.elm-verify-examples.meta
      // {
        description = "Verify examples in your docs";
        homepage = "https://github.com/stoeffel/elm-verify-examples";
        license = licenses.bsd3;
        maintainers = [ maintainers.turbomack ];
      };
  };

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

  elm-language-server = nodePkgs."@elm-tooling/elm-language-server" // {
    meta =
      with lib;
      nodePkgs."@elm-tooling/elm-language-server".meta
      // {
        description = "Language server implementation for Elm";
        homepage = "https://github.com/elm-tooling/elm-language-server";
        license = licenses.mit;
        maintainers = [ maintainers.turbomack ];
      };
  };

  elm-spa = nodePkgs."elm-spa".overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      makeWrapper
      old.nodejs.pkgs.node-gyp-build
    ];

    meta =
      with lib;
      nodePkgs."elm-spa".meta
      // {
        description = "Tool for building single page apps in Elm";
        homepage = "https://www.elm-spa.dev/";
        license = licenses.bsd3;
        maintainers = [ maintainers.ilyakooo0 ];
      };
  });

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

  elm-doc-preview = nodePkgs."elm-doc-preview".overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ old.nodejs.pkgs.node-gyp-build ];
  });
}
