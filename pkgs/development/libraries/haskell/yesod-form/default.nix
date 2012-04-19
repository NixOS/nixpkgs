{ cabal, blazeBuilder, blazeHtml, dataDefault, emailValidate
, hamlet, network, persistent, shakespeareCss, shakespeareJs, text
, time, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.0.0.2";
  sha256 = "1jvp0hw9kprwcwdxx1i2aazycf03i1vf8q5vjmdpynhgzyrpkrx1";
  buildDepends = [
    blazeBuilder blazeHtml dataDefault emailValidate hamlet network
    persistent shakespeareCss shakespeareJs text time transformers wai
    xssSanitize yesodCore yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Form handling support for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
