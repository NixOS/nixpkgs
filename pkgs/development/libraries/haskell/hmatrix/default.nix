{ cabal, binary, blas, gsl, liblapack, random, storableComplex
, vector
}:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.14.0.1";
  sha256 = "057ii711qsh5307bp3jqpvlhwp2iacr83whhjm5053b5psinj4z5";
  buildDepends = [ binary random storableComplex vector ];
  extraLibraries = [ blas gsl liblapack ];
  meta = {
    homepage = "https://github.com/albertoruiz/hmatrix";
    description = "Linear algebra and numerical computation";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.guibert
    ];
  };
})
