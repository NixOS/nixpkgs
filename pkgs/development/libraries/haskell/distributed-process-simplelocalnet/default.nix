{ cabal, binary, dataAccessor, distributedProcess, network
, networkMulticast, networkTransport, networkTransportTcp
, transformers
}:

cabal.mkDerivation (self: {
  pname = "distributed-process-simplelocalnet";
  version = "0.2.0.5";
  sha256 = "04cx5pb3pf4wpmqx1zhdc9lrfs0mb8zk7p1qxxlsqg0x63f3353w";
  buildDepends = [
    binary dataAccessor distributedProcess network networkMulticast
    networkTransport networkTransportTcp transformers
  ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "Simple zero-configuration backend for Cloud Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
