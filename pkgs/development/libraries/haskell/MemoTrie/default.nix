{ cabal, void }:

cabal.mkDerivation (self: {
  pname = "MemoTrie";
  version = "0.6.1";
  sha256 = "1bx0xd28irxjrq181wirx0vdrdj4qg4n4wj7ya27lkh408mwsxm6";
  buildDepends = [ void ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/MemoTrie";
    description = "Trie-based memo functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
