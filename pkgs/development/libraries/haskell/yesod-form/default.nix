{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, byteable, dataDefault, emailValidate, hamlet, hspec, network
, persistent, resourcet, shakespeare, shakespeareCss, shakespeareJs
, text, time, transformers, wai, xssSanitize, yesodCore
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.3.8.2";
  sha256 = "0sx2rk4z4hzwz3nzcg487wm5bdpdm612ikp0slfph1wkzc39h12a";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeHtml blazeMarkup byteable
    dataDefault emailValidate hamlet network persistent resourcet
    shakespeare shakespeareCss shakespeareJs text time transformers wai
    xssSanitize yesodCore yesodPersistent
  ];
  testDepends = [ hspec text time ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Form handling support for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
