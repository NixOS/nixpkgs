{ cabal, arithmoi, circlePacking, colour, dataDefault, diagramsCore
, diagramsLib, forceLayout, HUnit, lens, MonadRandom, mtl
, QuickCheck, split, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-contrib";
  version = "0.6.1";
  sha256 = "0z92sfgqpfk401lzkvnsg3ij05795qc61c4lx12glbmdpfhilcpi";
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
