{ cabal, Boolean, MemoTrie, NumInstances }:

cabal.mkDerivation (self: {
  pname = "vector-space";
  version = "0.8.4";
  sha256 = "1hrilbv44lrqm9p3z97xw8nlgxam98abll4iqik8a4d6ky225bwq";
  buildDepends = [ Boolean MemoTrie NumInstances ];
  meta = {
    description = "Vector & affine spaces, linear maps, and derivatives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
