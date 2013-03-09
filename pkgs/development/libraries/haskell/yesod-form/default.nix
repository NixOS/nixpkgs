{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, cryptoApi, dataDefault, emailValidate, hamlet, hspec, network
, persistent, shakespeareCss, shakespeareJs, text, time
, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.2.1.3";
  sha256 = "1mrqr6pfrhkk0vv9lhd4wxiic8d1hsraiqmjcqsfbpdyrc6fqypq";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeHtml blazeMarkup cryptoApi
    dataDefault emailValidate hamlet network persistent shakespeareCss
    shakespeareJs text time transformers wai xssSanitize yesodCore
    yesodPersistent
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
