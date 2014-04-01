{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, text, time, transformers, wai
, waiTest, xmlConduit, xmlTypes, yesodCore, yesodForm
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "1.2.1.2";
  sha256 = "12b747sd5rrypv1i2b5rpa3qgpnzibwjw7rlv02hyz8g7kf6wvbm";
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup caseInsensitive
    cookie hspec htmlConduit httpTypes HUnit monadControl network
    persistent text time transformers wai waiTest xmlConduit xmlTypes
    yesodCore
  ];
  testDepends = [
    hspec htmlConduit HUnit text xmlConduit yesodCore yesodForm
  ];
  meta = {
    homepage = "http://www.yesodweb.com";
    description = "integration testing for WAI/Yesod Applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
