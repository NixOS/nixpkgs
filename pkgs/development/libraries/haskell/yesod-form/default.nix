{ cabal, blazeBuilder, blazeHtml, blazeMarkup, dataDefault
, emailValidate, hamlet, network, persistent, shakespeareCss
, shakespeareJs, text, time, transformers, wai, xssSanitize
, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.0.0.4";
  sha256 = "1wc7nrsf7r9zs24q2amy1zij5sfycs1arnrf8g769c7gihjhdqfd";
  buildDepends = [
    blazeBuilder blazeHtml blazeMarkup dataDefault emailValidate hamlet
    network persistent shakespeareCss shakespeareJs text time
    transformers wai xssSanitize yesodCore yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Form handling support for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
