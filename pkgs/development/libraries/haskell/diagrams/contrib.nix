{ cabal, colour, dataDefault, diagramsLib, forceLayout, lens, mtl
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-contrib";
  version = "0.6.0.3";
  sha256 = "0j0wmf2nksqh3rqmzyw468bp25zikc5icif5f3rfi1v06ghsk0i5";
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
