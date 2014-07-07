{ cabal, Diff, dualTree, ghcMod, ghcPaths, ghcSybUtils
, haskellSrcExts, hspec, HUnit, monoidExtras, mtl, QuickCheck
, rosezipper, semigroups, syb
}:

cabal.mkDerivation (self: {
  pname = "haskell-token-utils";
  version = "0.0.0.2";
  sha256 = "115lqddhjra3wjnj5n8gpm0iawf6m1l2ggjh2n8nbx6wjraghrrv";
  buildDepends = [
    dualTree ghcSybUtils haskellSrcExts monoidExtras mtl rosezipper
    semigroups syb
  ];
  testDepends = [
    Diff dualTree ghcMod ghcPaths ghcSybUtils haskellSrcExts hspec
    HUnit monoidExtras mtl QuickCheck rosezipper semigroups syb
  ];
  meta = {
    homepage = "https://github.com/alanz/haskell-token-utils";
    description = "Utilities to tie up tokens to an AST";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
