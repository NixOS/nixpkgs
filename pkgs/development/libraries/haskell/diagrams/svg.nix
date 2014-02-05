{ cabal, blazeMarkup, blazeSvg, colour, diagramsCore, diagramsLib
, filepath, hashable, lens, monoidExtras, mtl, split, time
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "1.0.1.2";
  sha256 = "1aaybkizlfc4ji7m2p2naw4ml1pacppkbfr2ygqlq0k3bg0cd36k";
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
