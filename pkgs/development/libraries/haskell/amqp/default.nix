{ cabal, binary, clock, connection, dataBinaryIeee754, hspec
, hspecExpectations, monadControl, network, split, text, xml
}:

cabal.mkDerivation (self: {
  pname = "amqp";
  version = "0.8.2";
  sha256 = "0hl9x6kbxdv32014k1w34d84wl4ivpiyg1ikpjr0nr9bsg3wr0gf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary clock connection dataBinaryIeee754 monadControl network
    split text xml
  ];
  testDepends = [
    binary clock connection dataBinaryIeee754 hspec hspecExpectations
    network split text
  ];
  meta = {
    homepage = "https://github.com/hreinhardt/amqp";
    description = "Client library for AMQP servers (currently only RabbitMQ)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
