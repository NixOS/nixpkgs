{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, cryptoApi, dataDefault, emailValidate, hamlet, network
, persistent, shakespeareCss, shakespeareJs, text, time
, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.1.3";
  sha256 = "1af1wdzwbw1a2bf991pgx52d9dap3cqpsr5h4yy4mid6p980slrb";
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
