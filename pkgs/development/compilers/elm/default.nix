{
  pkgs,
  lib,
  makeWrapper,
  nodejs ? pkgs.nodejs_18,
}:

let
  fetchElmDeps = pkgs.callPackage ./lib/fetchElmDeps.nix { };

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

  # Haskell packages that require ghc 8.10
  hs810Pkgs = import ./packages/ghc8_10 { inherit pkgs lib; };

  # Haskell packages that require ghc 9.2
  hs92Pkgs = import ./packages/ghc9_2 { inherit pkgs lib; };

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
    (hs96Pkgs self).elmPkgs
    // (hs92Pkgs self).elmPkgs
    // (hs810Pkgs self).elmPkgs
    // (patchedNodePkgs self)
    // basics;
in
lib.makeScope pkgs.newScope (
  self:
  assembleScope self (
    with self;
    {
      inherit fetchElmDeps nodejs;

      /*
        Node/NPM based dependencies can be upgraded using script `packages/generate-node-packages.sh`.

        * Packages which rely on `bin-wrap` will fail by default
          and can be patched using `patchBinwrap` function defined in `packages/lib.nix`.

        * Packages which depend on npm installation of elm can be patched using
          `patchNpmElm` function also defined in `packages/lib.nix`.
      */
      elmLib =
        let
          hsElmPkgs = (hs810Pkgs self) // (hs96Pkgs self);
        in
        import ./lib {
          inherit lib;
          inherit (pkgs) writeScriptBin stdenv;
          inherit (self) elm;
        };

      elm-json = callPackage ./packages/elm-json { };

      elm-test-rs = callPackage ./packages/elm-test-rs { };

      elm-test = callPackage ./packages/elm-test { };

      lamdera = callPackage ./packages/lamdera { };
    }
  )
)
