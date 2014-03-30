{ cabal, conduit, conduitExtra, cprngAes, dataDefaultClass, network
, networkConduit, resourcet, streamingCommons, tls, transformers
, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "2.0.3.2";
  sha256 = "1dqaq1z4gb3sya41hiwsxgl4f0v7sqza7aazf2vc7dd5x5izp02w";
  buildDepends = [
    conduit conduitExtra cprngAes dataDefaultClass network
    networkConduit resourcet streamingCommons tls transformers wai warp
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "HTTP over SSL/TLS support for Warp via the TLS package";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
