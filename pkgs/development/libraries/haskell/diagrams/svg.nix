{ cabal, blazeMarkup, blazeSvg, colour, diagramsCore, diagramsLib
, filepath, hashable, lens, monoidExtras, mtl, split, time
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "1.0.2";
  sha256 = "1pbkr5qg3cjk2c23aas5y9f0bk5nsding4r4c4fdkxj49ipi4ys1";
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
