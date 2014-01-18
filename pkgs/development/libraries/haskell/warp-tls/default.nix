{ cabal, certificate, conduit, cprngAes, cryptocipher
, cryptoRandomApi, network, networkConduit, pem, tls, tlsExtra
, transformers, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "2.0.1";
  sha256 = "0qz02awxrfqmmckias21dh0irmf44vamv24jjjrbb6bjxbr4ldd0";
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
