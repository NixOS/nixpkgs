{ cabal, mtl, optparseApplicative, reducers, split, stm, tagged
, tasty, transformers
}:

cabal.mkDerivation (self: {
  pname = "tasty-rerun";
  version = "1.1.1";
  sha256 = "1xgjf47bvahankyic18l5fcda4dlfbd4j2lxqv3v5hhwk7zgvcp8";
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
