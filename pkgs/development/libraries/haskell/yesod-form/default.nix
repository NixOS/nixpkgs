{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, cryptoApi, dataDefault, emailValidate, hamlet, network
, persistent, shakespeareCss, shakespeareJs, text, time
, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.1.4.1";
  sha256 = "0rsyrvcnq69b68avl13z4fmvq7hf6p50wpr63hp0pysvcicgyjsm";
  buildDepends = [
    attoparsec blazeBuilder blazeHtml blazeMarkup cryptoApi dataDefault
    emailValidate hamlet network persistent shakespeareCss
    shakespeareJs text time transformers wai xssSanitize yesodCore
    yesodPersistent
  ];
  noHaddock = true;
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Form handling support for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
