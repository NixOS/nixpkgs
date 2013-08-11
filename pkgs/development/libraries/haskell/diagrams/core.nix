{ cabal, dualTree, MemoTrie, monoidExtras, newtype, semigroups
, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-core";
  version = "0.7";
  sha256 = "00ba31imq91w6lzy8blgxawr06igrjfrg4adrqy650wip8jafqwq";
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
