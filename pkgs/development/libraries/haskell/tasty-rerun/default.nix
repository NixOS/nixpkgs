{ cabal, mtl, optparseApplicative, reducers, split, stm, tagged
, tasty, transformers
}:

cabal.mkDerivation (self: {
  pname = "tasty-rerun";
  version = "1.1.2";
  sha256 = "0vgx6l9yd21aiwivd6zp67rgjly1j2wwqdmx99p17prr430rm4id";
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
