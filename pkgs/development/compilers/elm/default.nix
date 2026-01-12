{
  pkgs,
  lib,
  makeWrapper,
  nodejs ? pkgs.nodejs_20,
  config,
}:

let
  fetchElmDeps = pkgs.callPackage ./lib/fetchElmDeps.nix { };

  # Haskell packages that require ghc 9.8
  hs98Pkgs = import ./packages/ghc9_8 { inherit pkgs lib; };

  # Haskell packages that require ghc 9.6
  hs96Pkgs = import ./packages/ghc9_6 {
    inherit
      pkgs
      lib
      makeWrapper
      nodejs
      fetchElmDeps
      ;
  };

  assembleScope = self: basics: (hs98Pkgs self).elmPkgs // (hs96Pkgs self).elmPkgs // basics;
in
lib.makeScope pkgs.newScope (
  self:
  assembleScope self (
    with self;
    {
      inherit fetchElmDeps nodejs;

      elmLib = import ./lib {
        inherit lib;
        inherit (pkgs) writeScriptBin stdenv;
        inherit (self) elm;
      };

      elm-analyse = callPackage ./packages/elm-analyse { };

      elm-doc-preview = callPackage ./packages/elm-doc-preview { };

      elm-git-install = callPackage ./packages/elm-git-install { };

      elm-graphql = callPackage ./packages/elm-graphql { };

      elm-json = callPackage ./packages/elm-json { };

      elm-language-server = callPackage ./packages/elm-language-server { };

      elm-live = callPackage ./packages/elm-live { };

      elm-optimize-level-2 = callPackage ./packages/elm-optimize-level-2 { };

      elm-review = callPackage ./packages/elm-review { };

      elm-spa = callPackage ./packages/elm-spa { };

      elm-test-rs = callPackage ./packages/elm-test-rs { };

      elm-test = callPackage ./packages/elm-test { };

      elm-upgrade = callPackage ./packages/elm-upgrade { };

      elm-verify-examples = callPackage ./packages/elm-verify-examples { };

      elm-xref = callPackage ./packages/elm-xref { };

      lamdera = callPackage ./packages/lamdera { };
    }
    // lib.optionalAttrs config.allowAliases {
      create-elm-app = throw "'elmPackages.create-elm-app' has not had a release since December 2020, so it was removed."; # Added 2025-11-15
      elm-pages = throw "'elmPackages.elm-pages' has been removed, as it was broken in nixpkgs and was not maintained."; # Added 2025-11-15
    }
  )
)
