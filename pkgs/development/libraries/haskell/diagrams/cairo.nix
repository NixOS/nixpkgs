{ cabal, cairo, colour, dataDefaultClass, diagramsCore, diagramsLib
, filepath, hashable, JuicyPixels, lens, mtl, optparseApplicative
, pango, split, statestack, time, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "1.2";
  sha256 = "0vzjp1i5hk971r7f55gpdl0jibrjg9j4ny7p408kb8zl2ynlxv6l";
  buildDepends = [
    cairo colour dataDefaultClass diagramsCore diagramsLib filepath
    hashable JuicyPixels lens mtl optparseApplicative pango split
    statestack time transformers vector
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Cairo backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
