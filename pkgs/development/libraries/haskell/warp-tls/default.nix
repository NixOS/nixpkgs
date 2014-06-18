{ cabal, cprngAes, dataDefaultClass, network, streamingCommons, tls
, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "3.0.0";
  sha256 = "14gm43a811v9h87ia2b9y9kynafrvq3yw89gswlj832469jx9sfw";
  buildDepends = [
    cprngAes dataDefaultClass network streamingCommons tls wai warp
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "HTTP over SSL/TLS support for Warp via the TLS package";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
