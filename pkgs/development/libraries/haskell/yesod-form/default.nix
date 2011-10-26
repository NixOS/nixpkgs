{ cabal, blazeBuilder, blazeHtml, dataDefault, emailValidate
, hamlet, network, persistent, shakespeareCss, shakespeareJs, text
, time, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "0.3.3";
  sha256 = "1lym9h7xr26i36n62cvbdyzjxna1p0alyhx9qhi5zhg0xz4nd3xq";
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
