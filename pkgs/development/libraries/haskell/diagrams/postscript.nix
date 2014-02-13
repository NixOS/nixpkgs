{ cabal, diagramsCore, diagramsLib, dlist, filepath, hashable, lens
, monoidExtras, mtl, semigroups, split, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-postscript";
  version = "1.0.1.2";
  sha256 = "0im1w70qi8qs2z8x41v7pwvk1alfaw1h8k0683njzd5sfz2m1gny";
  buildDepends = [
    diagramsCore diagramsLib dlist filepath hashable lens monoidExtras
    mtl semigroups split vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams/";
    description = "Postscript backend for diagrams drawing EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
