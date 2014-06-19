{ cabal, async, blazeBuilder, caseInsensitive, doctest, hashable
, hspec, HTTP, httpDate, httpTypes, HUnit, liftedBase, network
, QuickCheck, simpleSendfile, streamingCommons, text, time
, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "3.0.0.3";
  sha256 = "0lhmhgbza49lkbay6ydj5h1g04qzs4jx2wyq4bhddjrpmxsdsy2y";
  buildDepends = [
    blazeBuilder caseInsensitive hashable httpDate httpTypes network
    simpleSendfile streamingCommons text unixCompat void wai
  ];
  testDepends = [
    async blazeBuilder caseInsensitive doctest hashable hspec HTTP
    httpDate httpTypes HUnit liftedBase network QuickCheck
    simpleSendfile streamingCommons text time transformers unixCompat
    void wai
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
