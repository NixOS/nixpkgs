{ cabal, blazeBuilder, caseInsensitive, classyPreludeConduit
, conduit, dataDefault, httpConduit, httpTypes, liftedBase
, monadControl, network, networkConduit, text, wai, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.1.1.1";
  sha256 = "0xg6xw0j61db75smys2fgjn0nzv2dy8c1ha4m828ssnxlic98lk2";
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
