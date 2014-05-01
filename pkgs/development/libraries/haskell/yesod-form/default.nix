{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, blazeMarkup
, byteable, dataDefault, emailValidate, hamlet, hspec, network
, persistent, resourcet, shakespeare, shakespeareCss, shakespeareJs
, text, time, transformers, wai, xssSanitize, yesodCore
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-form";
  version = "1.3.8.3";
  sha256 = "0fw2hza78z3cv2d9laawi60vjd9msk7a6im3wsq3vbbfh6rh5br9";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeHtml blazeMarkup byteable
    dataDefault emailValidate hamlet network persistent resourcet
    shakespeare shakespeareCss shakespeareJs text time transformers wai
    xssSanitize yesodCore yesodPersistent
  ];
  testDepends = [ hspec text time ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Form handling support for Yesod Web Framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
