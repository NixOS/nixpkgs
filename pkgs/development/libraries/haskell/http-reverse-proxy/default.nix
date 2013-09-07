{ cabal, blazeBuilder, caseInsensitive, classyPrelude, conduit
, dataDefault, hspec, httpConduit, httpTypes, liftedBase
, monadControl, network, networkConduit, text, transformers, wai
, waiLogger, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.2.1";
  sha256 = "1f1087igr4kisb3z3lxznb85sfhzr2s08am1za3jg8cgffmrais8";
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
