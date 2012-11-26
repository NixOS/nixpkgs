{ cabal, blazeBuilder, caseInsensitive, classyPreludeConduit
, conduit, httpConduit, httpTypes, liftedBase, monadControl
, network, networkConduit, text, wai, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.1.0.6";
  sha256 = "0ybhzyim8b2k1kv5bz0qbignj5lwf8pbpqmrp1vrvyz8a2iy71c8";
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
