{ cabal, dualTree, MemoTrie, monoidExtras, newtype, semigroups
, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-core";
  version = "0.6";
  sha256 = "15frd5jdzkgpdcvyyhd0mbi5d4a69ajcnxawa1gafl4c3byz1778";
  buildDepends = [
    dualTree MemoTrie monoidExtras newtype semigroups vectorSpace
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
