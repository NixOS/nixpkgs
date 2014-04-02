{ cabal, deepseq, erf, HUnit, ieee754, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, vector
, vectorThUnbox
}:

cabal.mkDerivation (self: {
  pname = "math-functions";
  version = "0.1.5.2";
  sha256 = "12cznf7gwia1ki7xhvlhk5p8d09zrdvfgn07pkp4sfrwsc4vijcy";
  buildDepends = [ deepseq erf vector vectorThUnbox ];
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
