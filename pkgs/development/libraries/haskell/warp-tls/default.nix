{ cabal, conduit, conduitExtra, cprngAes, dataDefaultClass, network
, networkConduit, resourcet, streamingCommons, tls, transformers
, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "warp-tls";
  version = "2.0.3.3";
  sha256 = "03fjghsa9zvrvg7ickph577zzr62n91gsb99v9k47s4nd2xri2rj";
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
