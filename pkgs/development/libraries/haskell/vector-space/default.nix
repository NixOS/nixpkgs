{ cabal, Boolean, MemoTrie, NumInstances }:

cabal.mkDerivation (self: {
  pname = "vector-space";
  version = "0.8.3";
  sha256 = "1wiwzbzp2fcavps0fqc9rwm50b2yv0ysgs78d29mvwcya1ywwxgw";
  buildDepends = [ Boolean MemoTrie NumInstances ];
  meta = {
    description = "Vector & affine spaces, linear maps, and derivatives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
