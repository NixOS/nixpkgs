{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, caseInsensitive, cookie, hspec, htmlConduit, httpTypes, HUnit
, monadControl, network, persistent, poolConduit, text, time
, transformers, wai, waiTest, xmlConduit, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "0.3.3";
  sha256 = "1jb410r905wd26swh2rk59nbyy389gcfz261adhb69awmsyql5x3";
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup caseInsensitive
    cookie hspec htmlConduit httpTypes HUnit monadControl network
    persistent poolConduit text time transformers wai waiTest
    xmlConduit xmlTypes
  ];
  meta = {
    homepage = "http://www.yesodweb.com";
    description = "integration testing for WAI/Yesod Applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
