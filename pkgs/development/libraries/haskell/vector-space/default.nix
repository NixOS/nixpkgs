{ cabal, Boolean, MemoTrie, NumInstances }:

cabal.mkDerivation (self: {
  pname = "vector-space";
  version = "0.8.7";
  sha256 = "1i3c34b3ngksmw4blhldap8fiw1jddm2h1qyr92csn3cllj6j1vm";
  buildDepends = [ Boolean MemoTrie NumInstances ];
  meta = {
    description = "Vector & affine spaces, linear maps, and derivatives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
