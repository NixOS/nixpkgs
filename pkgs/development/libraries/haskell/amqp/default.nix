{ cabal, binary, dataBinaryIeee754, network, text, xml }:

cabal.mkDerivation (self: {
  pname = "amqp";
  version = "0.5.0";
  sha256 = "1i02pp184r1iq40mz16m9qh8i3h1jmf3ykpg67j3i1732cks8n8w";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary dataBinaryIeee754 network text xml ];
  meta = {
    homepage = "https://github.com/hreinhardt/amqp";
    description = "Client library for AMQP servers (currently only RabbitMQ)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
