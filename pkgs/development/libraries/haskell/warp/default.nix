{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, doctest, hashable, hspec, HTTP, httpAttoparsec, httpDate
, httpTypes, HUnit, liftedBase, network, networkConduit, QuickCheck
, simpleSendfile, time, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "2.0.0.1";
  sha256 = "12n1r1qahngfhrqhlbfjl11rmy5la9mpd0h4ai0lzdxkakb89pxl";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    httpAttoparsec httpDate httpTypes liftedBase network networkConduit
    simpleSendfile transformers unixCompat void wai
  ];
  testDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit doctest
    hashable hspec HTTP httpAttoparsec httpDate httpTypes HUnit
    liftedBase network networkConduit QuickCheck simpleSendfile time
    transformers unixCompat void wai
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
