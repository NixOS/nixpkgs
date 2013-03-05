{ cabal, dualTree, MemoTrie, monoidExtras, newtype, semigroups
, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-core";
  version = "0.6.0.1";
  sha256 = "0kw0rxk9a2zkpnbx4bfd0japm75y29ldvdn7i3c93kvz0p6jc2wa";
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
