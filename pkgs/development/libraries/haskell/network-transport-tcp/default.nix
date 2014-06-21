{ cabal, dataAccessor, network_2_4_1_2, networkTransport
, networkTransportTests
}:

cabal.mkDerivation (self: {
  pname = "network-transport-tcp";
  version = "0.4.0";
  sha256 = "1jjf1dj67a7l3jg3qgbg0hrjfnx1kr9n7hfvqssq7kr8sq1sc49v";
  buildDepends = [ dataAccessor network_2_4_1_2 networkTransport ];
  testDepends = [ network_2_4_1_2 networkTransport networkTransportTests ];
  # tests should be enabled when network-transport-tests 0.2.0.0 released.
  doCheck = false;

  meta = {
    homepage = "http://haskell-distributed.github.com";
    description = "TCP instantiation of Network.Transport";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
