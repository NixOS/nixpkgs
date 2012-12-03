{ cabal, attoparsec, blazeHtml, blazeMarkup, caseInsensitive, hspec
, htmlConduit, httpTypes, HUnit, monadControl, network, persistent
, poolConduit, text, transformers, wai, waiTest, xmlConduit
, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "yesod-test";
  version = "0.3.2";
  sha256 = "1wd5iwar6jxbv0p7p47js4spivwhph98h403bnmf3dl7069nyjcs";
  buildDepends = [
    attoparsec blazeHtml blazeMarkup caseInsensitive hspec htmlConduit
    httpTypes HUnit monadControl network persistent poolConduit text
    transformers wai waiTest xmlConduit xmlTypes
  ];
  meta = {
    homepage = "http://www.yesodweb.com";
    description = "integration testing for WAI/Yesod Applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
