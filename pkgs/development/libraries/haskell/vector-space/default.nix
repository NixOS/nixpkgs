{ cabal, Boolean, MemoTrie, NumInstances }:

cabal.mkDerivation (self: {
  pname = "vector-space";
  version = "0.8.6";
  sha256 = "03kz2qhnynbgs4vk7348zjkkakzzwvxhbasl0lcazj1cx1ay7c4l";
  buildDepends = [ Boolean MemoTrie NumInstances ];
  meta = {
    description = "Vector & affine spaces, linear maps, and derivatives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
