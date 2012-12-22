{ cabal, blazeBuilder, caseInsensitive, classyPreludeConduit
, conduit, httpConduit, httpTypes, liftedBase, monadControl
, network, networkConduit, text, wai, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.1.0.7";
  sha256 = "1fshng7bcpzjq5iqnvl2qsyia9yi80b8sbif18a3w86gsw5xcakk";
  buildDepends = [
    blazeBuilder caseInsensitive classyPreludeConduit conduit
    httpConduit httpTypes liftedBase monadControl network
    networkConduit text wai warp word8
  ];
  meta = {
    homepage = "https://github.com/fpco/http-reverse-proxy";
    description = "Reverse proxy HTTP requests, either over raw sockets or with WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
