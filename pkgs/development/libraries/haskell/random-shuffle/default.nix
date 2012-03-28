{ cabal, MonadRandom, random }:

cabal.mkDerivation (self: {
  pname = "random-shuffle";
  version = "0.0.3";
  sha256 = "120yh2k1n57vc9mi4dlnvv9dr79qaz4dsbvl3qp3y82mdz8maifw";
  buildDepends = [ MonadRandom random ];
  meta = {
    description = "Random shuffle implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
