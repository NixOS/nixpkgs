{ cabal, blazeSvg, cmdargs, colour, diagramsCore, diagramsLib
, filepath, monoidExtras, mtl, split, time, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "0.7";
  sha256 = "0vfykrx29dxii9mdjjkia5a42jfg4hbzgxzv5rp7zvf3fz9w8w1x";
  buildDepends = [
    blazeSvg cmdargs colour diagramsCore diagramsLib filepath
    monoidExtras mtl split time vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "SVG backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
