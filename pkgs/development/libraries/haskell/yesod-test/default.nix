{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, text, time, transformers, wai
, waiExtra, waiTest, xmlConduit, xmlTypes, yesodCore, yesodForm
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "1.2.3.1";
  sha256 = "0q4w7q22d8hvsg939w686fb295v8cznnhqlfd1bh0v2lp9dih4ms";
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup caseInsensitive
    cookie hspec htmlConduit httpTypes HUnit monadControl network
    persistent text time transformers wai waiExtra waiTest xmlConduit
    xmlTypes yesodCore
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
