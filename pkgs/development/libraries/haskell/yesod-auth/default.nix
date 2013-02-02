{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, hamlet
, httpConduit, httpTypes, liftedBase, mimeMail, network, persistent
, persistentTemplate, pureMD5, pwstoreFast, random, SHA
, shakespeareCss, shakespeareJs, text, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.1.4";
  sha256 = "060548zbjsvf6zvixiyic729fd9862z3qwz349ric60jfa20cdpx";
  buildDepends = [
    aeson authenticate blazeHtml blazeMarkup hamlet httpConduit
    httpTypes liftedBase mimeMail network persistent persistentTemplate
    pureMD5 pwstoreFast random SHA shakespeareCss shakespeareJs text
    transformers unorderedContainers wai yesodCore yesodForm yesodJson
    yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
