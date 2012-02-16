{ cabal, blazeBuilder, blazeHtml, Cabal, dataDefault, emailValidate
, hamlet, network, persistent, shakespeareCss, shakespeareJs, text
, time, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "0.4.1";
  sha256 = "0l55n7zml3sf8f2qmmii5cq53awajc4vfr5msrm8kvi3ivzjld0s";
  buildDepends = [
    blazeBuilder blazeHtml Cabal dataDefault emailValidate hamlet
    network persistent shakespeareCss shakespeareJs text time
    transformers wai xssSanitize yesodCore yesodPersistent
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
