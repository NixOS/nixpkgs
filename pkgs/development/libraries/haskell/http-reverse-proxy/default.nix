{ cabal, blazeBuilder, caseInsensitive, classyPrelude, conduit
, dataDefault, httpConduit, httpTypes, liftedBase, monadControl
, network, networkConduit, text, wai, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.1.1.3";
  sha256 = "0z2h2xbvg034snfh3hzc0v2zp5j57lcak2h4vz10lwaqr3jxqnpn";
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
