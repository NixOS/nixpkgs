{ cabal, MemoTrie, newtype, semigroups, vectorSpace
, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-core";
  version = "0.5.0.1";
  sha256 = "073fk9cxm1kh92alr51dgwps9wxc5w3470axc6q7w91sk5cskpxy";
  buildDepends = [
    MemoTrie newtype semigroups vectorSpace vectorSpacePoints
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Core libraries for diagrams EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
