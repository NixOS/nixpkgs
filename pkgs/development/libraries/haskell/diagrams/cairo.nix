{ cabal, cairo, colour, dataDefaultClass, diagramsCore, diagramsLib
, filepath, hashable, JuicyPixels, lens, mtl, optparseApplicative
, split, statestack, time, vector
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "1.1.0.2";
  sha256 = "0y36cx89rlbmj470a6g11wlzkwzznjkjmkcpm7dzbxvfxw4pp70z";
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
