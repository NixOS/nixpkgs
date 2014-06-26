{ cabal, aeson, Cabal, deepseq, either, filepath, haskellSrcExts
, hseCpp, mtl, optparseApplicative, tagged
}:

cabal.mkDerivation (self: {
  pname = "haskell-packages";
  version = "0.2.4.1";
  sha256 = "014zcq27rwsgj3n4kdgswbppr5yzf3lnj5gnv45r3i5c3rd1mz6k";
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
