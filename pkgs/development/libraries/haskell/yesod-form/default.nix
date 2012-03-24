{ cabal, blazeBuilder, blazeHtml, dataDefault, emailValidate
, hamlet, network, persistent, shakespeareCss, shakespeareJs, text
, time, transformers, wai, xssSanitize, yesodCore, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "0.4.2.1";
  sha256 = "0zpmyqxbknz8pdib1gdf410jv4xndn4pphdigagqxl5m5c2hi1v2";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
