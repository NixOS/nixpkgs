{ cabal, dualTree, lens, MemoTrie, monoidExtras, newtype
, semigroups, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-core";
  version = "1.2.0.1";
  sha256 = "01rzd2zdg0pv7b299z6s6i6l6xggiszb2qs00vh5dbss295n1sps";
  buildDepends = [
    dualTree lens MemoTrie monoidExtras newtype semigroups vectorSpace
    vectorSpacePoints
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Core libraries for diagrams EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
