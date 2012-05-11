{ cabal, void }:

cabal.mkDerivation (self: {
  pname = "MemoTrie";
  version = "0.5";
  sha256 = "07knq5ccsyicznvr25vlbzadrgdw2aic71hhbv6v16wra1f17gbf";
  buildDepends = [ void ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/MemoTrie";
    description = "Trie-based memo functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
