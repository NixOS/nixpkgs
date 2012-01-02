{ cabal, binary, blas, gsl, liblapack, storableComplex, vector }:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.13.0.0";
  sha256 = "1jlibgg2nrgajw2ny0dq88f5mhrffi7kda9bb8sp9szf4a0kd4wd";
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
