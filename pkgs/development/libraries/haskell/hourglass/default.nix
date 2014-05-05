{ cabal, deepseq, HUnit, mtl, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "hourglass";
  version = "0.1.2";
  sha256 = "18jvl4f8vfabvd9vlhxjjlswc80x8w4h6gdflvzdkjrknnyk118j";
  buildDepends = [ deepseq ];
  testDepends = [
    deepseq HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 time
  ];
  meta = {
    homepage = "https://github.com/vincenthz/hs-hourglass";
    description = "simple performant time related library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
