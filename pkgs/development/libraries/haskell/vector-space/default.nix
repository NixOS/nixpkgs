{cabal, Boolean, MemoTrie} :

cabal.mkDerivation (self : {
  pname = "vector-space";
  version = "0.7.3";
  sha256 = "00lzhml1pc328iw9cip9yh54n0yqkwz1mxkv4gq2wlb7bzpfq1fx";
  propagatedBuildInputs = [ Boolean MemoTrie ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/vector-space";
    description = "Vector & affine spaces, linear maps, and derivatives (requires ghc 6.9 or better)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
