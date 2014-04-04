{ cabal, active, colour, dataDefaultClass, diagramsCore, filepath
, fingertree, hashable, intervals, lens, MemoTrie, monoidExtras
, optparseApplicative, safe, semigroups, tagged, vectorSpace
, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "1.1.0.4";
  sha256 = "0i3n07qi7gnlbxxsd8j7wgqdqbjp8h44z837lajfwd108j01fw0i";
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
