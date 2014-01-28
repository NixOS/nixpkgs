{ cabal, mtl, optparseApplicative, reducers, split, stm, tagged
, tasty, transformers
}:

cabal.mkDerivation (self: {
  pname = "tasty-rerun";
  version = "1.1.0";
  sha256 = "0nizjmz9z41r1vzxzld760x6ga4lqycwfazhddk570w3x2dzm6p2";
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
