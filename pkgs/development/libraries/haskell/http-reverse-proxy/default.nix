{ cabal, basicPrelude, blazeBuilder, caseInsensitive, conduit
, dataDefault, hspec, httpConduit, httpTypes, liftedBase
, monadControl, network, networkConduit, text, transformers, wai
, waiLogger, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.2.1.1";
  sha256 = "12hfbl8239ivrqvd5pi1avlcb381q861958qwyf20jc5jpwvjjgj";
  buildDepends = [
    basicPrelude blazeBuilder caseInsensitive conduit dataDefault
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
