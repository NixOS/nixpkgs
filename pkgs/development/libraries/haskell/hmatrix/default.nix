{ cabal, binary, blas, gsl, liblapack, random, storableComplex
, vector
}:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.14.1.0";
  sha256 = "10fvbk3k2fgac46a86mc8g0s5gsw1p1bz4k57gn6dzgwh73mxjx7";
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
