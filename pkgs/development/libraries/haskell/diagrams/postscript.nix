{ cabal, dataDefaultClass, diagramsCore, diagramsLib, dlist
, filepath, hashable, lens, monoidExtras, mtl, semigroups, split
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-postscript";
  version = "1.1";
  sha256 = "0l077libp6h8ka9ygkmajvzdymndlhx60nb5f6jaqvp7yx80hz3m";
  buildDepends = [
    dataDefaultClass diagramsCore diagramsLib dlist filepath hashable
    lens monoidExtras mtl semigroups split vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "Postscript backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
