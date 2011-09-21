{ cabal, binary, blas, gsl, HUnit, liblapack, QuickCheck, random
, storableComplex, vector
}:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.12.0.1";
  sha256 = "1lnq1892vzx094d84jfs2477m3w47xgmqvnvzignwgfi470d9lw5";
  buildDepends = [
    binary HUnit QuickCheck random storableComplex vector
  ];
  extraLibraries = [ blas gsl liblapack ];
  meta = {
    homepage = "http://perception.inf.um.es/hmatrix";
    description = "Linear algebra and numerical computation";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.guibert
      self.stdenv.lib.maintainers.simons
    ];
  };
})
