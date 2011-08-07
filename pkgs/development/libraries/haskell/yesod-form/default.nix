{cabal, blazeBuilder, blazeHtml, dataDefault, emailValidate,
 hamlet, network, persistent, text, transformers, wai,
 webRoutesQuasi, xssSanitize, yesodCore, yesodPersistent} :

cabal.mkDerivation (self : {
  pname = "yesod-form";
  version = "0.2.0.1";
  sha256 = "17ap5jf433s8a3k97vskvc7wxa8qdx03fynh3881zg5s1kqj3b3r";
  propagatedBuildInputs = [
    blazeBuilder blazeHtml dataDefault emailValidate hamlet network
    persistent text transformers wai webRoutesQuasi xssSanitize
    yesodCore yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Form handling support for Yesod Web Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
