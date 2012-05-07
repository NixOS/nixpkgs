{ cabal, void }:

cabal.mkDerivation (self: {
  pname = "MemoTrie";
  version = "0.4.12";
  sha256 = "0wjpfy1vlk3fjbdj924viv1wji28kx3w9hsaz7hd0gfs77y9vjza";
  buildDepends = [ void ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/MemoTrie";
    description = "Trie-based memo functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
