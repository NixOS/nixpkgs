{ cabal, blazeBuilder, caseInsensitive, classyPrelude, conduit
, dataDefault, hspec, httpConduit, httpTypes, liftedBase
, monadControl, network, networkConduit, text, transformers, wai
, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.1.1.6";
  sha256 = "0fh61rm3k00shzis2dkgifnkfn78vx124dzmmdzlf550kjmhxb9l";
  buildDepends = [
    blazeBuilder caseInsensitive classyPrelude conduit dataDefault
    httpConduit httpTypes liftedBase monadControl network
    networkConduit text wai warp word8
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
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
