{ cabal, Boolean, MemoTrie, NumInstances }:

cabal.mkDerivation (self: {
  pname = "vector-space";
  version = "0.8.1";
  sha256 = "0khbi46i9q585nhxhf842wsdifcj1i1dqm84hj0r36474rfh55z5";
  buildDepends = [ Boolean MemoTrie NumInstances ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/vector-space";
    description = "Vector & affine spaces, linear maps, and derivatives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
