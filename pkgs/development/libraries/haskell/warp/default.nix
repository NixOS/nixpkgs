{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, hashable, hspec, httpAttoparsec, httpTypes, HUnit
, liftedBase, network, networkConduit, QuickCheck, simpleSendfile
, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.9.2";
  sha256 = "0l4iq7dl7iv9sf0bj52g577x9i84miscfr27b2vm8g8n6306jr77";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    httpAttoparsec httpTypes liftedBase network networkConduit
    simpleSendfile transformers unixCompat void wai
  ];
  testDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    hspec httpAttoparsec httpTypes HUnit liftedBase network
    networkConduit QuickCheck simpleSendfile transformers unixCompat
    void wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
