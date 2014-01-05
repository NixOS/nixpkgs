{ cabal, certificate, conduit, cprngAes, cryptocipher
, cryptoRandomApi, network, networkConduit, pem, tls, tlsExtra
, transformers, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "2.0.0.1";
  sha256 = "1hwzwlqmq1nkxmp3zjplnkrh80v0awbrb2fwzd4ndyla8akgia1p";
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
