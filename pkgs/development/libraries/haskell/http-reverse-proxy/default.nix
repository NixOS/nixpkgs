{ cabal, async, blazeBuilder, caseInsensitive, conduit
, conduitExtra, dataDefaultClass, hspec, httpClient, httpConduit
, httpTypes, liftedBase, monadControl, network, networkConduit
, resourcet, streamingCommons, text, transformers, wai, waiLogger
, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.3.1.4";
  sha256 = "0j7k6njyp3qss08gja5p62zvqxdh7bpqfbzvkm23gdv8v1bgh5h6";
  buildDepends = [
    async blazeBuilder caseInsensitive conduit conduitExtra
    dataDefaultClass httpClient httpTypes liftedBase monadControl
    network networkConduit resourcet streamingCommons text transformers
    wai waiLogger word8
  ];
  testDepends = [
    blazeBuilder conduit hspec httpConduit httpTypes liftedBase network
    networkConduit transformers wai warp
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/fpco/http-reverse-proxy";
    description = "Reverse proxy HTTP requests, either over raw sockets or with WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
