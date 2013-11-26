{ cabal, active, colour, dataDefaultClass, diagramsCore, filepath
, fingertree, intervals, lens, MemoTrie, monoidExtras, NumInstances
, optparseApplicative, safe, semigroups, tagged, vectorSpace
, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "1.0";
  sha256 = "0afrk9y7h5g9cqds9b7b0jvz4xylaxyj3q9aj5415ldwwzdf6cc8";
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
