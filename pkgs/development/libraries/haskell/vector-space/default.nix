{ cabal, Boolean, MemoTrie, NumInstances }:

cabal.mkDerivation (self: {
  pname = "vector-space";
  version = "0.8.0";
  sha256 = "1wd8psw2s98m8yfr8mam5abz2bhvxz1r78w703hgca8rr6hiaz0g";
  buildDepends = [ Boolean MemoTrie NumInstances ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/vector-space";
    description = "Vector & affine spaces, linear maps, and derivatives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
