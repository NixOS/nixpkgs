{ cabal, blazeBuilder, caseInsensitive, classyPreludeConduit
, conduit, httpConduit, httpTypes, liftedBase, monadControl
, network, networkConduit, text, wai, warp, word8
}:

cabal.mkDerivation (self: {
  pname = "http-reverse-proxy";
  version = "0.1.0.5";
  sha256 = "1x1m9vklgg6x8niry8c5fxcjpmsmrpxv7j2i5h38hp1hbka3mpr0";
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
