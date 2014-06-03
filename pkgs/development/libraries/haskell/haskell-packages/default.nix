{ cabal, aeson, Cabal, deepseq, either, filepath, haskellSrcExts
, hseCpp, mtl, optparseApplicative, tagged
}:

cabal.mkDerivation (self: {
  pname = "haskell-packages";
  version = "0.2.4";
  sha256 = "1ygpa2k0hyx2xwny33kr0h847zvvsp4z1pwqrd92sf7vzpyz5nch";
  buildDepends = [
    aeson Cabal deepseq either filepath haskellSrcExts hseCpp mtl
    optparseApplicative tagged
  ];
  meta = {
    homepage = "http://documentup.com/haskell-suite/haskell-packages";
    description = "Haskell suite library for package management and integration with Cabal";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
