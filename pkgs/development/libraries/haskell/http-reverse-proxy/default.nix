{ cabal, blazeBuilder, caseInsensitive, classyPrelude, conduit
, dataDefault, httpConduit, httpTypes, liftedBase, monadControl
, network, networkConduit, text, wai, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.1.1.2";
  sha256 = "179j6zfmx3g6gc7mzhzhl7ymxkijg9vahjvwjwm0wm15vna52iqa";
  buildDepends = [
    blazeBuilder caseInsensitive classyPrelude conduit dataDefault
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
