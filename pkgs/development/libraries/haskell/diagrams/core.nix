{ cabal, dualTree, lens, MemoTrie, monoidExtras, newtype
, semigroups, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-core";
  version = "1.2";
  sha256 = "0qlkick9ppwaignh179w65gmiq5as1nsi1ymficdw1p0jldi5f51";
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
