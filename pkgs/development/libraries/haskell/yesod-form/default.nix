{cabal, blazeBuilder, blazeHtml, dataDefault, emailValidate, hamlet,
 network, persistent, text, transformers, wai, webRoutesQuasi,
 xssSanitize, yesodCore, yesodPersistent}:

cabal.mkDerivation (self : {
  pname = "yesod-form";
  version = "0.2.0";
  sha256 = "1dwwndrb09bqfzrarxpiw29xqvxk70iy8b2vcy0rl6g2wvrcm8an";
  propagatedBuildInputs = [
    blazeBuilder blazeHtml dataDefault emailValidate hamlet
    network persistent text transformers wai webRoutesQuasi
    xssSanitize yesodCore yesodPersistent
  ];
  noHaddock = true;
  meta = {
    description = "Form handling support for Yesod Web Framework";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

