{ cabal, colour, dataDefault, diagramsLib, forceLayout, lens, mtl
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-contrib";
  version = "0.6";
  sha256 = "059ljwsbrkzj2wvx9q4viinz46nw5lf4yjmx2c1dmwaqfz3i7j7i";
  buildDepends = [
    colour dataDefault diagramsLib forceLayout lens mtl vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "Collection of user contributions to diagrams EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
