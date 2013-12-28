{ cabal, random, transformers }:

cabal.mkDerivation (self: {
  pname = "markov-chain";
  version = "0.0.3.2";
  sha256 = "0shld9b6vdi5274wyhwpw5ggfm6xi5j7m3ag989bxarhrfzjxgdk";
  buildDepends = [ random transformers ];
  meta = {
    homepage = "http://code.haskell.org/~thielema/markov-chain/";
    description = "Markov Chains for generating random sequences with a user definable behaviour";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
