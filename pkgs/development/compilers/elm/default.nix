{
  pkgs,
  lib,
  makeWrapper,
  nodejs ? pkgs.nodejs_20,
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

  # Patched, originally npm-downloaded, packages
  patchedNodePkgs = import ./packages/node {
    inherit
      pkgs
      lib
      nodejs
      makeWrapper
      ;
  };

  assembleScope =
    self: basics:
    (hs98Pkgs self).elmPkgs // (hs96Pkgs self).elmPkgs // (patchedNodePkgs self) // basics;
in
lib.makeScope pkgs.newScope (
  self:
  assembleScope self (
    with self;
    {
      inherit fetchElmDeps nodejs;

      /*
        Node/NPM based dependencies can be upgraded using script `packages/generate-node-packages.sh`.

        * Packages which depend on npm installation of elm can be patched using
          `patchNpmElm` function defined in `packages/lib.nix`.
      */
      elmLib = import ./lib {
        inherit lib;
        inherit (pkgs) writeScriptBin stdenv;
        inherit (self) elm;
      };

      elm-json = callPackage ./packages/elm-json { };

      elm-review = callPackage ./packages/elm-review { };

      elm-test-rs = callPackage ./packages/elm-test-rs { };

      elm-test = callPackage ./packages/elm-test { };

      lamdera = callPackage ./packages/lamdera { };
    }
  )
)
