{ cabal }:

cabal.mkDerivation (self: {
  pname = "MemoTrie";
  version = "0.4.10";
  sha256 = "1hkraq33sai046gwqlabc9nkz6jbl6vgj0c6lc6j4j5h5d8v08kk";
  meta = {
    homepage = "http://haskell.org/haskellwiki/MemoTrie";
    description = "Trie-based memo functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
