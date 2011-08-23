{ cabal, binary, blas, gsl, HUnit, liblapack, QuickCheck, random
, storableComplex, vector
}:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.11.1.0";
  sha256 = "19915xmf6m2092s1rzwirxy0rwjcr6482y5wg4bil0afm0xjnb9n";
  buildDepends = [
    binary HUnit QuickCheck random storableComplex vector
  ];
  extraLibraries = [ gsl liblapack blas ];
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
