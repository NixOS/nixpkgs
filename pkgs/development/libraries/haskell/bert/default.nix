{ cabal, async, binary, binaryConduit, conduit, mtl, network
, networkConduit, parsec, smallcheck, tasty, tastyHunit
, tastySmallcheck, time, void
}:

cabal.mkDerivation (self: {
  pname = "bert";
  version = "1.2.2";
  sha256 = "1dlq9fl5d2adprcybs4d4cyhj9q2c1l4kcc6vnnyhbyn201gxgpn";
  buildDepends = [
    binary binaryConduit conduit mtl network networkConduit parsec time
    void
  ];
  testDepends = [
    async binary network smallcheck tasty tastyHunit tastySmallcheck
  ];
  meta = {
    homepage = "https://github.com/feuerbach/bert";
    description = "BERT implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
