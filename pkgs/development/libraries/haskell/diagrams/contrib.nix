{ cabal, colour, dataDefault, diagramsLib, forceLayout, HUnit, lens
, mtl, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-contrib";
  version = "0.6.0.4";
  sha256 = "190wn56bmrpbijsxf793xbjy1a4rci3vj40ri6i2dv3an6p0ka0q";
  buildDepends = [
    colour dataDefault diagramsLib forceLayout lens mtl vectorSpace
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
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
