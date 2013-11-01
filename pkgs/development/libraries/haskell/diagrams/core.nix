{ cabal, dualTree, MemoTrie, monoidExtras, newtype, semigroups
, vectorSpace, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-core";
  version = "0.7.0.1";
  sha256 = "1826f6yrb0ch07y4bjb1cnqi8giphn2i6g45484qr6bfbb8wj5dg";
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
