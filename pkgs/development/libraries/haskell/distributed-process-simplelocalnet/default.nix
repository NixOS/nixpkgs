{ cabal, binary, dataAccessor, distributedProcess, network
, networkMulticast, networkTransport, networkTransportTcp
, transformers
}:

cabal.mkDerivation (self: {
  pname = "distributed-process-simplelocalnet";
  version = "0.2.0.9";
  sha256 = "0bkb26bfpmyhh26hgznnw073kvk78ws6lqi86pxrgnnm9sx5mi21";
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
