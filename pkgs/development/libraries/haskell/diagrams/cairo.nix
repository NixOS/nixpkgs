{ cabal, cairo, colour, dataDefaultClass, diagramsCore, diagramsLib
, filepath, hashable, lens, mtl, split, statestack, time
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "1.0.1.2";
  sha256 = "040x3zdrr70kg10isby6xp8mswvjd84xiz2rf7w1y66g9izdgfmc";
  buildDepends = [
    cairo colour dataDefaultClass diagramsCore diagramsLib filepath
    hashable lens mtl split statestack time
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Cairo backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
