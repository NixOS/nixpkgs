{ cabal, dataDefaultClass, diagramsCore, diagramsLib, dlist
, filepath, hashable, lens, monoidExtras, mtl, semigroups, split
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-postscript";
  version = "1.0.2.1";
  sha256 = "0c3svrkv2wyls1mb75gzv9nfjy0vgfw4bshd6q6z036jn75q9y0r";
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
