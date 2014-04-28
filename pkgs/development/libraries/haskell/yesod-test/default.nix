{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, text, time, transformers, wai
, waiTest, xmlConduit, xmlTypes, yesodCore, yesodForm
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "1.2.1.4";
  sha256 = "1m3fh0s46s2d7q876bvqj1iww7s7nhpcjsnj1547hm7ymfsa29r8";
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup caseInsensitive
    cookie hspec htmlConduit httpTypes HUnit monadControl network
    persistent text time transformers wai waiTest xmlConduit xmlTypes
    yesodCore
  ];
  testDepends = [
    hspec htmlConduit HUnit text wai xmlConduit yesodCore yesodForm
  ];
  meta = {
    homepage = "http://www.yesodweb.com";
    description = "integration testing for WAI/Yesod Applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
