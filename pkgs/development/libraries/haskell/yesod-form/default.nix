{cabal, blazeBuilder, blazeHtml, dataDefault, emailValidate,
 hamlet, network, persistent, text, transformers, webRoutesQuasi,
 xssSanitize, yesodCore, yesodPersistent} :

cabal.mkDerivation (self : {
  pname = "yesod-form";
  version = "0.1.0.1";
  sha256 = "108652256g82xapsn0w4cbficq4ikwlsa8yis2zq7izxk48livlm";
  propagatedBuildInputs = [
    blazeBuilder blazeHtml dataDefault emailValidate hamlet network
    persistent text transformers webRoutesQuasi xssSanitize yesodCore
    yesodPersistent
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
