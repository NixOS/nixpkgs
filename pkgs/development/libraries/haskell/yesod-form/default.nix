{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, byteable, dataDefault, emailValidate, hamlet, hspec, network
, persistent, resourcet, shakespeare, shakespeareCss, shakespeareJs
, text, time, transformers, wai, xssSanitize, yesodCore
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.3.8.1";
  sha256 = "0cyvyr3whrbswawv5rcfmq9nhk3kf4d3vgfm8z01prcqdsc4yh21";
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
