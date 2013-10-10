{ cabal, erf, HUnit, ieee754, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "math-functions";
  version = "0.1.4.0";
  sha256 = "1cijm224gfvd7rvrrndcks8d7aj89c9qv0m4wx2qqngr7rk78kav";
  buildDepends = [ erf vector ];
  testDepends = [
    HUnit ieee754 QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 vector
  ];
  meta = {
    homepage = "https://github.com/bos/math-functions";
    description = "Special functions and Chebyshev polynomials";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
