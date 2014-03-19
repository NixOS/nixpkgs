{ cabal, active, colour, dataDefaultClass, diagramsCore, filepath
, fingertree, hashable, intervals, lens, MemoTrie, monoidExtras
, optparseApplicative, safe, semigroups, tagged, vectorSpace
, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "1.1.0.2";
  sha256 = "1kfzf9cjb74vpfdjargjy8hg0rdhvry96f9ysmya3j7ws8lqrwdh";
  buildDepends = [
    active colour dataDefaultClass diagramsCore filepath fingertree
    hashable intervals lens MemoTrie monoidExtras optparseApplicative
    safe semigroups tagged vectorSpace vectorSpacePoints
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
