{ cabal, async, blazeBuilder, caseInsensitive, conduit
, conduitExtra, dataDefaultClass, hspec, httpClient, httpConduit
, httpTypes, liftedBase, monadControl, network, networkConduit
, resourcet, streamingCommons, text, transformers, wai, waiLogger
, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.4.0.1";
  sha256 = "0gygmykxsy6rs3xmwb24s5c3brmabdgxb1w0ak82vyvfvsnqxz1h";
  buildDepends = [
    async blazeBuilder caseInsensitive conduit conduitExtra
    dataDefaultClass httpClient httpTypes liftedBase monadControl
    network resourcet streamingCommons text transformers wai waiLogger
    word8
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
