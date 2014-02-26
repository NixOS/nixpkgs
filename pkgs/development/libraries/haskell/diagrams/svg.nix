{ cabal, blazeMarkup, blazeSvg, colour, diagramsCore, diagramsLib
, filepath, hashable, lens, monoidExtras, mtl, split, time
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "1.0.1.3";
  sha256 = "0brbvzwh7yi3400wrdpkmw6jfd2nhi238zddhid76lmx2q9zxvvx";
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
