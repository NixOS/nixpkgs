{ cabal, erf, vector }:

cabal.mkDerivation (self: {
  pname = "math-functions";
  version = "0.1.1.0";
  sha256 = "0qb0hbfzd1g8cz3dkm8cs2wknz08b63vn7nljmynk794y64b1klp";
  buildDepends = [ erf vector ];
  meta = {
    homepage = "https://github.com/bos/math-functions";
    description = "Special functions and Chebyshev polynomials";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
