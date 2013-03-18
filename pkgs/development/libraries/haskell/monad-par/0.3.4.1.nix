{ cabal, abstractDeque, abstractPar, deepseq, HUnit, monadParExtras
, mtl, mwcRandom, parallel, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, testFrameworkTh
, time
}:

cabal.mkDerivation (self: {
  pname = "monad-par";
  version = "0.3.4.1";
  sha256 = "0v0gnxzv49zvmgm2cb20dlb8m7mn4chpwrc61g4zp69nabjpwwm8";
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
