{ cabal, arithmoi, circlePacking, colour, dataDefault
, dataDefaultClass, diagramsCore, diagramsLib, forceLayout, HUnit
, lens, MonadRandom, mtl, parsec, QuickCheck, semigroups, split
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-contrib";
  version = "1.1.1.4";
  sha256 = "0n2r6k65kxvk5mwm193yhzwnj3bhignq4xdslfpv2m1afdvws2y1";
  buildDepends = [
    arithmoi circlePacking colour dataDefault dataDefaultClass
    diagramsCore diagramsLib forceLayout lens MonadRandom mtl parsec
    semigroups split text vectorSpace vectorSpacePoints
  ];
  testDepends = [
    diagramsLib HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "Collection of user contributions to diagrams EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
