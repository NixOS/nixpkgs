{ cabal, async, blazeBuilder, caseInsensitive, conduit
, dataDefaultClass, hspec, httpClient, httpConduit, httpTypes
, liftedBase, monadControl, network, networkConduit, resourcet
, text, transformers, wai, waiLogger, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.3.1.2";
  sha256 = "0c7xg5l5di87dwn0pq5ymh1bj5zzj7hmj6cvwp3b1q6cb3fcwfnp";
  buildDepends = [
    async blazeBuilder caseInsensitive conduit dataDefaultClass
    httpClient httpTypes liftedBase monadControl network networkConduit
    resourcet text transformers wai waiLogger word8
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
