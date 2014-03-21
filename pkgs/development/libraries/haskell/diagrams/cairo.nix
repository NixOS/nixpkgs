{ cabal, cairo, colour, dataDefaultClass, diagramsCore, diagramsLib
, filepath, hashable, JuicyPixels, lens, mtl, optparseApplicative
, split, statestack, time, vector
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "1.1";
  sha256 = "0x66qdwni3pwc2lrqy5jnyz7nqbfpr1086g1ndy6cxx8hp632zaf";
  buildDepends = [
    cairo colour dataDefaultClass diagramsCore diagramsLib filepath
    hashable JuicyPixels lens mtl optparseApplicative split statestack
    time vector
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Cairo backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
