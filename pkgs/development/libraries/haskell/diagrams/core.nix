{ cabal, dualTree, lens, MemoTrie, monoidExtras, newtype
, semigroups, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-core";
  version = "1.1.0.1";
  sha256 = "1jr827cd3qa631glwc9h247w0wnrx84gj2iwxj18b4y78d0ajz69";
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
