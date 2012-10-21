{ cabal, dataAccessor, network, networkTransport }:

cabal.mkDerivation (self: {
  pname = "network-transport-tcp";
  version = "0.3.0";
  sha256 = "0x2rz0h890bfay52af2wcvja706dr4r6wgfs9csjf7y3jf53nc63";
  buildDepends = [ dataAccessor network networkTransport ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "TCP instantiation of Network.Transport";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
