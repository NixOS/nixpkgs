{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, hamlet
, httpConduit, liftedBase, mimeMail, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, SHA, shakespeareCss, text
, transformers, unorderedContainers, wai, yesodCore, yesodForm
, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.1.1.6";
  sha256 = "0xbr8q7rv73hsh90pdb5cl00pd4mx3q74q0dqampha0y2lpq6124";
  buildDepends = [
    aeson authenticate blazeHtml blazeMarkup hamlet httpConduit
    liftedBase mimeMail persistent persistentTemplate pureMD5
    pwstoreFast random SHA shakespeareCss text transformers
    unorderedContainers wai yesodCore yesodForm yesodJson
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
