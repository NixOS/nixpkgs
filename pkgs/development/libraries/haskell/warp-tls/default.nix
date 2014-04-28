{ cabal, conduit, conduitExtra, cprngAes, dataDefaultClass, network
, networkConduit, resourcet, streamingCommons, tls, transformers
, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "2.0.5";
  sha256 = "11nc5drys75mjfqww87rs2clhxpx485q008y42f2ymj7s5856db4";
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
