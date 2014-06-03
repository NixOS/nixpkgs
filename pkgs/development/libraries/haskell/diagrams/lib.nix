{ cabal, active, colour, dataDefaultClass, diagramsCore, dualTree
, filepath, fingertree, hashable, intervals, JuicyPixels, lens
, MemoTrie, monoidExtras, optparseApplicative, safe, semigroups
, tagged, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "1.2";
  sha256 = "1gdc2k1dmqfv6pcznzngfv0gqsm7pd7ga65xjmd0rzyl8nqk4k3n";
  buildDepends = [
    active colour dataDefaultClass diagramsCore dualTree filepath
    fingertree hashable intervals JuicyPixels lens MemoTrie
    monoidExtras optparseApplicative safe semigroups tagged vectorSpace
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
