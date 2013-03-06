{ cabal, dualTree, MemoTrie, monoidExtras, newtype, semigroups
, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-core";
  version = "0.6.0.2";
  sha256 = "1g4b1zabgfdpaf7y3804r3w04ll4sqqrf71rm9389dg17ghc1q85";
  buildDepends = [
    dualTree MemoTrie monoidExtras newtype semigroups vectorSpace
    vectorSpacePoints
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Core libraries for diagrams EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
