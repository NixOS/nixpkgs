{ cabal, dataAccessor, network, networkTransport }:

cabal.mkDerivation (self: {
  pname = "network-transport-tcp";
  version = "0.2.0.3";
  sha256 = "0jlw59ib6yzkv2qggza571k2nhxnwvwj42zdgzz6wh2bgdyihayw";
  buildDepends = [ dataAccessor network networkTransport ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "TCP instantation of Network.Transport";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
