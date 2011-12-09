{ cabal, binary, blas, gsl, HUnit, liblapack, QuickCheck, random
, storableComplex, vector
}:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.12.0.2";
  sha256 = "08i3vi0vs6wpyvjsjpqrxp8lw0f89cgzwv1j27y7i2yfp4xmrw8d";
  buildDepends = [
    binary HUnit QuickCheck random storableComplex vector
  ];
  extraLibraries = [ blas gsl liblapack ];
  configureFlags = "-fvector";
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
