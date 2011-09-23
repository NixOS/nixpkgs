{ cabal, Boolean, MemoTrie, NumInstances }:

cabal.mkDerivation (self: {
  pname = "vector-space";
  version = "0.7.8";
  sha256 = "195g9zsb73w4a0fcfz0kank6gyqajww0qiqivr4fy0bik2nsr6ry";
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
