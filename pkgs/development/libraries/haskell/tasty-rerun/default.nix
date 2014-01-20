{ cabal, mtl, optparseApplicative, reducers, split, stm, tagged
, tasty, transformers
}:

cabal.mkDerivation (self: {
  pname = "tasty-rerun";
  version = "1.0.0";
  sha256 = "0vpgsb5fgvb9mx07zq53slqxxk2vvr2c9c9p1fhrm9qadfirsqc8";
  buildDepends = [
    mtl optparseApplicative reducers split stm tagged tasty
    transformers
  ];
  meta = {
    homepage = "http://github.com/ocharles/tasty-rerun";
    description = "Run tests by filtering the test tree depending on the result of previous test runs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
