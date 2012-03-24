{ cabal, erf, vector }:

cabal.mkDerivation (self: {
  pname = "math-functions";
  version = "0.1.1.1";
  sha256 = "1256fyd80z6yf61a5a90b3lad7hj0n59cyn741nkdh8p6hqrsi7z";
  buildDepends = [ erf vector ];
  meta = {
    homepage = "https://github.com/bos/math-functions";
    description = "Special functions and Chebyshev polynomials";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
