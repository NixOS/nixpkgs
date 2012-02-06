{ cabal, binary, blas, gsl, liblapack, storableComplex, vector }:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.13.1.0";
  sha256 = "0pl5z6zsxyvbdfdng77r2c4isq6d4wbyzx2qs9r8rbn6glaxwrmp";
  buildDepends = [ binary storableComplex vector ];
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
