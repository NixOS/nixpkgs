{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, cryptoApi, dataDefault, emailValidate, hamlet, hspec, network
, persistent, resourcet, shakespeareCss, shakespeareJs, text, time
, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.3.6";
  sha256 = "1gynm078i9iak0iirdrnp7pmz9rx4gq96cb2q5n617hww9m5p0j2";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeHtml blazeMarkup cryptoApi
    dataDefault emailValidate hamlet network persistent resourcet
    shakespeareCss shakespeareJs text time transformers wai xssSanitize
    yesodCore yesodPersistent
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
