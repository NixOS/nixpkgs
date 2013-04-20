{ cabal, dataAccessor, dataAccessorTransformers, HUnit
, lockfreeQueue, mtl, network, networkTransport
, networkTransportTests, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "network-transport-tcp";
  version = "0.3.1";
  sha256 = "15i4qbx1s3dxaixn6kd2z1hsymfvpqzf4jpqd3mcbpjlgrn6craf";
  buildDepends = [ dataAccessor network networkTransport ];
  testDepends = [
    dataAccessor dataAccessorTransformers HUnit lockfreeQueue mtl
    network networkTransport networkTransportTests QuickCheck
    testFramework testFrameworkHunit testFrameworkQuickcheck2
    transformers
  ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "TCP instantiation of Network.Transport";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
