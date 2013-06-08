{ cabal, blazeSvg, cmdargs, colour, diagramsCore, diagramsLib
, filepath, monoidExtras, mtl, split, time, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "0.6.0.1";
  sha256 = "0x4yjm1wdhicknls1y3fhdg89m8wcvfk2svabww9075w6ras79qk";
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
