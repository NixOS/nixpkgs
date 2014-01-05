{ cabal, blazeSvg, colour, diagramsCore, diagramsLib, filepath
, lens, monoidExtras, mtl, split, time, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "1.0";
  sha256 = "13v1q9d2004k4324b0yxlmwrsanb0mk9pz0gqfxvx9v27sry12sl";
  buildDepends = [
    blazeSvg colour diagramsCore diagramsLib filepath lens monoidExtras
    mtl split time vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "SVG backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
