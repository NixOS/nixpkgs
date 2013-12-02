{ cabal, certificate, conduit, cprngAes, cryptocipher
, cryptoRandomApi, network, networkConduit, pem, tls, tlsExtra
, transformers, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "1.4.2";
  sha256 = "05mbf73859n2ns3bdnw24i7vygr4kysyxfq0xdkmmrd47fh3k9r6";
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
