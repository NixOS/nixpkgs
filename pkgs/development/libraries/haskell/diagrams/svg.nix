{ cabal, blazeSvg, cmdargs, colour, diagramsCore, diagramsLib
, filepath, monoidExtras, mtl, split, time, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "0.8.0.1";
  sha256 = "0ar7z46759s75fff0132mf51q53fvp2fkyqhw8b3lszsxvqs4r7y";
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
