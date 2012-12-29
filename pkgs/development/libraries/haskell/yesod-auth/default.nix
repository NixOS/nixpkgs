{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, hamlet
, httpConduit, liftedBase, mimeMail, network, persistent
, persistentTemplate, pureMD5, pwstoreFast, random, SHA
, shakespeareCss, shakespeareJs, text, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.1.3";
  sha256 = "0rlp56jsb0cwm1z303b7l9iy5hbip18vlm7fisna4agbf4rj2k0z";
  buildDepends = [
    aeson authenticate blazeHtml blazeMarkup hamlet httpConduit
    liftedBase mimeMail network persistent persistentTemplate pureMD5
    pwstoreFast random SHA shakespeareCss shakespeareJs text
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
