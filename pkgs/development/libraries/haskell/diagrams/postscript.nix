{ cabal, dataDefaultClass, diagramsCore, diagramsLib, dlist
, filepath, hashable, lens, monoidExtras, mtl, semigroups, split
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-postscript";
  version = "1.0.2.4";
  sha256 = "0vjzvjyrbmnjgl8ln58a44nhh4abq5q2c6fvlpxpfhxh2ligsmas";
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
