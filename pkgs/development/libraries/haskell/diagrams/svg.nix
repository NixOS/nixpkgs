{ cabal, blazeSvg, cmdargs, colour, diagramsCore, diagramsLib
, filepath, monoidExtras, mtl, split, time, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-svg";
  version = "0.6";
  sha256 = "0yiqilpksgsy87dxx4664pgbbgqcr98j1da4krb751x0yxkglyh5";
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
