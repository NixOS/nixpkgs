{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, text, time, transformers, wai
, waiTest, xmlConduit, xmlTypes, yesodCore, yesodForm
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "1.2.2";
  sha256 = "1vf5g83mj2a38f34llg6wa63whj13p0vgbzfvi3ic5j7qy5gb8g5";
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
