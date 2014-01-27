{ cabal, blazeMarkup, blazeSvg, colour, diagramsCore, diagramsLib
, filepath, hashable, lens, monoidExtras, mtl, split, time
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "1.0.1";
  sha256 = "15adic3dl4qqrd63jx1rc1w4wx270vm7zc3hr69mnh0wn0cr0ga5";
  buildDepends = [
    blazeMarkup blazeSvg colour diagramsCore diagramsLib filepath
    hashable lens monoidExtras mtl split time vectorSpace
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "SVG backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
