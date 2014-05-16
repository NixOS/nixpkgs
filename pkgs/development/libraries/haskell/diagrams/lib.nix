{ cabal, active, colour, dataDefaultClass, diagramsCore, filepath
, fingertree, hashable, intervals, lens, MemoTrie, monoidExtras
, optparseApplicative, safe, semigroups, tagged, vectorSpace
, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "1.1.0.7";
  sha256 = "0ad5105aa2ds0hrx0184jhvzw1mw5l659hx745rsyl8wyi5yrcy7";
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
