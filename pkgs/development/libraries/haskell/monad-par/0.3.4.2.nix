{ cabal, abstractDeque, abstractPar, deepseq, HUnit, monadParExtras
, mtl, mwcRandom, parallel, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, testFrameworkTh
, time
}:

cabal.mkDerivation (self: {
  pname = "monad-par";
  version = "0.3.4.2";
  sha256 = "1k10m4w2g92psahsvcyi98sc31wg5anijp46lbsipi2r2gxxc7bs";
  buildDepends = [
    abstractDeque abstractPar deepseq monadParExtras mtl mwcRandom
    parallel
  ];
  testDepends = [
    abstractDeque abstractPar deepseq HUnit monadParExtras mtl
    mwcRandom QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkTh time
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/simonmar/monad-par";
    description = "A library for parallel programming based on a monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
