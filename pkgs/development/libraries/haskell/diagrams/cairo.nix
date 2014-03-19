{ cabal, cairo, colour, dataDefaultClass, diagramsCore, diagramsLib
, filepath, hashable, JuicyPixels, lens, mtl, optparseApplicative
, split, statestack, time, vector
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "1.1.0.1";
  sha256 = "04s3z3j3xqx4q4chdysip2ngjbw4k7gd12s5zlbvx88d3jg0bcrs";
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
