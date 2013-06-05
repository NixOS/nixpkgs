{ cabal, pipes, stm, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-concurrency";
  version = "1.1.0";
  sha256 = "05xpwxhf08yf88ya89f8gcy4vphi6qxyccf2yiyi5zrf6c2pkr00";
  buildDepends = [ pipes stm transformers ];
  meta = {
    description = "Concurrency for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
