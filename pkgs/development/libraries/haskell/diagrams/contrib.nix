{ cabal, arithmoi, circlePacking, colour, dataDefault
, dataDefaultClass, diagramsCore, diagramsLib, forceLayout, HUnit
, lens, MonadRandom, mtl, parsec, QuickCheck, semigroups, split
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-contrib";
  version = "1.0.0.1";
  sha256 = "0h0rgy2wlmqicrq4zqr1pdff7b7l7ylm1z82iy3adxf38ca2r6y2";
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
