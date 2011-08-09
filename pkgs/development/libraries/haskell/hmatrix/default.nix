{cabal, HUnit, QuickCheck, binary, storableComplex, vector, gsl, liblapack, blas} :

cabal.mkDerivation (self : {
  pname = "hmatrix";
  version = "0.11.1.0";
  sha256 = "19915xmf6m2092s1rzwirxy0rwjcr6482y5wg4bil0afm0xjnb9n";
  propagatedBuildInputs = [
    HUnit QuickCheck binary storableComplex vector
    gsl liblapack blas
  ];
  meta = {
    homepage = "http://perception.inf.um.es/hmatrix";
    description = "Linear algebra and numerical computation";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.guibert
    ];
  };
})
