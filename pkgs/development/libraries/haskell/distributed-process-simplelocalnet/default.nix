{ cabal, binary, dataAccessor, distributedProcess, network
, networkMulticast, networkTransport, networkTransportTcp
, transformers
}:

cabal.mkDerivation (self: {
  pname = "distributed-process-simplelocalnet";
  version = "0.2.0.7";
  sha256 = "0jxbxacvdg4pf65s6r48nck45g8dfsarks3m2pdn73gjn4cd81c7";
  isLibrary = true;
  isExecutable = true;
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
