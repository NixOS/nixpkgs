{ cabal, active, colour, dataDefaultClass, diagramsCore, filepath
, fingertree, intervals, lens, MemoTrie, monoidExtras, NumInstances
, optparseApplicative, safe, semigroups, tagged, vectorSpace
, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "1.0.0.1";
  sha256 = "1ilkc8dh1ma0wwmzgy6x3a6q6bwlw7dfv3mb24a5ny4i3wgvsnv8";
  buildDepends = [
    active colour dataDefaultClass diagramsCore filepath fingertree
    intervals lens MemoTrie monoidExtras NumInstances
    optparseApplicative safe semigroups tagged vectorSpace
    vectorSpacePoints
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
