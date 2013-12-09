{ cabal, basicPrelude, blazeBuilder, caseInsensitive, conduit
, dataDefault, hspec, httpClient, httpConduit, httpTypes
, liftedBase, monadControl, network, networkConduit, resourcet
, text, transformers, wai, waiLogger, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.3.0";
  sha256 = "0wwrcm3hhbq9kawk3s12s8ws82vancmc8a5d29f6871jfq3vvzc2";
  buildDepends = [
    basicPrelude blazeBuilder caseInsensitive conduit dataDefault
    httpClient httpTypes liftedBase monadControl network networkConduit
    resourcet text wai waiLogger word8
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
