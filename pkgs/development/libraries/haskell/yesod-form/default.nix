{ cabal, blazeBuilder, blazeHtml, dataDefault, emailValidate
, hamlet, network, persistent, shakespeareCss, shakespeareJs, text
, time, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "0.3.4";
  sha256 = "05hvffzhwb6x6cmpvpf60hbzm4lvn7gp47rvspm5k6y6d999az3l";
  buildDepends = [
    blazeBuilder blazeHtml dataDefault emailValidate hamlet network
    persistent shakespeareCss shakespeareJs text time transformers wai
    xssSanitize yesodCore yesodPersistent
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
