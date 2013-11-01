{ cabal, binary, clock, dataBinaryIeee754, hspec, hspecExpectations
, network, split, text, xml
}:

cabal.mkDerivation (self: {
  pname = "amqp";
  version = "0.7.0";
  sha256 = "09zazmbdw8nphbjkmixn2dpwdgkjqjfbn6jv522ykvrcnsn35kc4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary clock dataBinaryIeee754 network split text xml
  ];
  testDepends = [
    binary dataBinaryIeee754 hspec hspecExpectations network split text
  ];
  meta = {
    homepage = "https://github.com/hreinhardt/amqp";
    description = "Client library for AMQP servers (currently only RabbitMQ)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
