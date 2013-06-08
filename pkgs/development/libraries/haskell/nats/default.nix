{ cabal }:

cabal.mkDerivation (self: {
  pname = "nats";
  version = "0.1";
  sha256 = "08gh7jjmws70919hmqqmvnfqcpxr34f03jmg3lzmmhqvr15gm1vy";
  meta = {
    homepage = "http://github.com/ekmett/nats/";
    description = "Haskell 98 natural numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
