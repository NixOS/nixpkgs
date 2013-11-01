{ cabal, abstractDeque, abstractPar, deepseq, HUnit, monadParExtras
, mtl, mwcRandom, parallel, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, testFrameworkTh
, time
}:

cabal.mkDerivation (self: {
  pname = "monad-par";
  version = "0.3.4.5";
  sha256 = "0xwjx3l9ssyxaa49v8kz7ic54va1qy6dqa1z5gvww7a5gw1ll81p";
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
