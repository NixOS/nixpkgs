{ cabal, certificate, conduit, cprngAes, cryptocipher
, cryptoRandomApi, network, networkConduit, pem, tls, tlsExtra
, transformers, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "1.4.1.4";
  sha256 = "1w6i26r5xjjc594h53q07bad835ryg3k6vmbzf5d59xngfvm7b9k";
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
