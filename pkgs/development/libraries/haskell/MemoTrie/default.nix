{ cabal }:

cabal.mkDerivation (self: {
  pname = "MemoTrie";
  version = "0.4.11";
  sha256 = "0wlrsz9bsb7lkw1ja8x8jbm1v7558fg8npas1rnc5ikgfi0szzw4";
  meta = {
    homepage = "http://haskell.org/haskellwiki/MemoTrie";
    description = "Trie-based memo functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
