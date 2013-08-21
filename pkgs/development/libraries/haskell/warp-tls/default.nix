{ cabal, certificate, conduit, cprngAes, cryptocipher
, cryptoRandomApi, network, networkConduit, pem, tls, tlsExtra
, transformers, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "1.4.1.3";
  sha256 = "0g26cw86kjg61agplqskhjb41ywcydyfzb46pjjc38g77xlcm2wx";
  buildDepends = [
    certificate conduit cprngAes cryptocipher cryptoRandomApi network
    networkConduit pem tls tlsExtra transformers wai warp
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "HTTP over SSL/TLS support for Warp via the TLS package";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
