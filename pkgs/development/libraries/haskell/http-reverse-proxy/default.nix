{ cabal, blazeBuilder, caseInsensitive, classyPreludeConduit
, conduit, dataDefault, httpConduit, httpTypes, liftedBase
, monadControl, network, networkConduit, text, wai, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.1.1";
  sha256 = "0p04zpw1v0zhzri7wpikc0b8g7n21kgl8j8238vv7xqxapkal0pc";
  buildDepends = [
    blazeBuilder caseInsensitive classyPreludeConduit conduit
    dataDefault httpConduit httpTypes liftedBase monadControl network
    networkConduit text wai warp word8
  ];
  meta = {
    homepage = "https://github.com/fpco/http-reverse-proxy";
    description = "Reverse proxy HTTP requests, either over raw sockets or with WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
