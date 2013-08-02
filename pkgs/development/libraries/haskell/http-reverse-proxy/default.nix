{ cabal, blazeBuilder, caseInsensitive, classyPrelude, conduit
, dataDefault, hspec, httpConduit, httpTypes, liftedBase
, monadControl, network, networkConduit, text, transformers, wai
, waiLogger, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.2.0";
  sha256 = "01kqf9c2yr3x5jwzyn44gs76fbffpacxs2j89aa902l0rz6l8ral";
  buildDepends = [
    blazeBuilder caseInsensitive classyPrelude conduit dataDefault
    httpConduit httpTypes liftedBase monadControl network
    networkConduit text wai waiLogger warp word8
  ];
  testDepends = [
    blazeBuilder conduit hspec httpConduit httpTypes liftedBase network
    networkConduit transformers wai warp
  ];
  meta = {
    homepage = "https://github.com/fpco/http-reverse-proxy";
    description = "Reverse proxy HTTP requests, either over raw sockets or with WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
