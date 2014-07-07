{ cabal, deepseq, QuickCheck, random, testFramework
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "bloomfilter";
  version = "2.0.0.0";
  sha256 = "07fif8i5rinysli1mpi92k405kvw8va7w9v9w4wd5bylb87zy77f";
  buildDepends = [ deepseq ];
  testDepends = [
    QuickCheck random testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/bos/bloomfilter";
    description = "Pure and impure Bloom Filter implementations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
