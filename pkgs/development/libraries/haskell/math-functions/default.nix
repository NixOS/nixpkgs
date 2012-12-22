{ cabal, erf, vector }:

cabal.mkDerivation (self: {
  pname = "math-functions";
  version = "0.1.1.2";
  sha256 = "09q9647zxvvg7wi81r14qhhy64d1mwgy8kg0zkhdvg4rzw9j669v";
  buildDepends = [ erf vector ];
  meta = {
    homepage = "https://github.com/bos/math-functions";
    description = "Special functions and Chebyshev polynomials";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
