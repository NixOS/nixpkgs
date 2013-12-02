{ cabal, async, binary, binaryConduit, conduit, mtl, network
, networkConduit, parsec, smallcheck, tasty, tastyHunit
, tastySmallcheck, time, void
}:

cabal.mkDerivation (self: {
  pname = "bert";
  version = "1.2.1.1";
  sha256 = "1g5sm23cxlzc7lqdlrjn4f89g65ia2bhr25yfh286awxf23z8pyh";
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
