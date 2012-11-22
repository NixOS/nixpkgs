{ cabal, binary, dataAccessor, distributedProcess, network
, networkMulticast, networkTransport, networkTransportTcp
, transformers
}:

cabal.mkDerivation (self: {
  pname = "distributed-process-simplelocalnet";
  version = "0.2.0.8";
  sha256 = "01kzqfbrkl9zzknw0gbdh1c1lss911lphagn2sw6nzl9xpnhjqk0";
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
