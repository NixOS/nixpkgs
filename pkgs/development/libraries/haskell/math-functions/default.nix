{ cabal, erf, HUnit, ieee754, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "math-functions";
  version = "0.1.3.0";
  sha256 = "06wxr8fbhmsgkpyx2vimx9l6apk0p27mwrxrvbjk0b7m9vsg3ay5";
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
