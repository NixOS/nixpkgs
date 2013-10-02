{ cabal, binary, dataBinaryIeee754, network, text, xml }:

cabal.mkDerivation (self: {
  pname = "amqp";
  version = "0.6.0";
  sha256 = "0rfczmhf46sc3pxxb5gwv4ggsxkqkvdi4kkqdnrdpdhs7p41im2n";
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
