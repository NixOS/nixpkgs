{ cabal, cairo, colour, dataDefaultClass, diagramsCore, diagramsLib
, filepath, hashable, lens, mtl, split, statestack, time
}:

cabal.mkDerivation (self: {
  pname = "diagrams-cairo";
  version = "1.0.1";
  sha256 = "16h1xz5amn0yd3h9rss0skaq08k1cy91cncxb9ky020s0wcix9fm";
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
