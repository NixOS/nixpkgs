{cabal}:

cabal.mkDerivation (self : {
  pname = "MemoTrie";
  version = "0.4.9";
  sha256 = "f17dd0b73c1a11a6edb38fb6f457b9687f2e93aa4677e90f7ec482a528ac02e7";
  meta = {
    description = "Trie-based memo functions";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

