{ cabal, async, blazeBuilder, caseInsensitive, conduit
, conduitExtra, dataDefaultClass, hspec, httpClient, httpConduit
, httpTypes, liftedBase, monadControl, network, networkConduit
, resourcet, streamingCommons, text, transformers, wai, waiLogger
, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.3.1.7";
  sha256 = "0fhndk9zjv1kcqgrhj42brfg96p7flrcpy609asba1vc0i9213j4";
  buildDepends = [
    async blazeBuilder caseInsensitive conduit conduitExtra
    dataDefaultClass httpClient httpTypes liftedBase monadControl
    network networkConduit resourcet streamingCommons text transformers
    wai waiLogger word8
  ];
  testDepends = [
    blazeBuilder conduit conduitExtra hspec httpConduit httpTypes
    liftedBase network networkConduit resourcet streamingCommons
    transformers wai warp
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/fpco/http-reverse-proxy";
    description = "Reverse proxy HTTP requests, either over raw sockets or with WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
