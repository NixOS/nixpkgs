{ cabal, arithmoi, circlePacking, colour, dataDefault, diagramsCore
, diagramsLib, forceLayout, HUnit, lens, MonadRandom, mtl
, QuickCheck, split, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-contrib";
  version = "0.7";
  sha256 = "0dcj4rjvpgf0lmxgv50f8cpi6adkbfnsa4z4ay8khawhnn4af5ac";
  buildDepends = [
    arithmoi circlePacking colour dataDefault diagramsCore diagramsLib
    forceLayout lens MonadRandom mtl split vectorSpace
  ];
  testDepends = [
    diagramsLib HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "Collection of user contributions to diagrams EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
