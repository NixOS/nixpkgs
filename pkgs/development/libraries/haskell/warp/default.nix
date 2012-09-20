{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, httpTypes, liftedBase, network, networkConduit
, simpleSendfile, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.1.1";
  sha256 = "1y0p36nh43wilk110dxpvsws6blrjpik4w9aqj5i1r97wn7xg9ax";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit httpTypes
    liftedBase network networkConduit simpleSendfile transformers
    unixCompat void wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
