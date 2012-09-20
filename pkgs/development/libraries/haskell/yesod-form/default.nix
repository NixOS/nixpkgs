{ cabal, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, cryptoApi, dataDefault, emailValidate, hamlet, network
, persistent, shakespeareCss, shakespeareJs, text, time
, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.1.2";
  sha256 = "0kjnnav7zb21iig3vhhy61jlz2wsk8r8b7dh251mla5l8pi3dq3r";
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
