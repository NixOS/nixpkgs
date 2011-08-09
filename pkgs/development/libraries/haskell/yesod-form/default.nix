{ cabal, blazeBuilder, blazeHtml, dataDefault, emailValidate
, hamlet, network, persistent, text, time, transformers
, webRoutesQuasi, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "0.1.0.1";
  sha256 = "108652256g82xapsn0w4cbficq4ikwlsa8yis2zq7izxk48livlm";
  buildDepends = [
    blazeBuilder blazeHtml dataDefault emailValidate hamlet network
    persistent text time transformers webRoutesQuasi xssSanitize
    yesodCore yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Form handling support for Yesod Web Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
