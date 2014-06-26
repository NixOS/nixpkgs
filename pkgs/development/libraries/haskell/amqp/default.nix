{ cabal, binary, clock, connection, dataBinaryIeee754, hspec
, hspecExpectations, monadControl, network, split, text, vector
, xml
}:

cabal.mkDerivation (self: {
  pname = "amqp";
  version = "0.9";
  sha256 = "10yacflzvf7y21yi6frs88gdbhf5g4j99ag8mwv6jrwfzwqszs5j";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary clock connection dataBinaryIeee754 monadControl network
    split text vector xml
  ];
  testDepends = [
    binary clock connection dataBinaryIeee754 hspec hspecExpectations
    network split text vector
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/hreinhardt/amqp";
    description = "Client library for AMQP servers (currently only RabbitMQ)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
