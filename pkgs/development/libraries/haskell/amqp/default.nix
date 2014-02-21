{ cabal, binary, clock, connection, dataBinaryIeee754, hspec
, hspecExpectations, monadControl, network, split, text, xml
}:

cabal.mkDerivation (self: {
  pname = "amqp";
  version = "0.8.1";
  sha256 = "10infzs2siw9vv8jgsndv7c82bsh22cs2drrb73nxpwf73hy3rzm";
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
