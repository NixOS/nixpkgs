{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, hamlet
, httpConduit, liftedBase, mimeMail, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, SHA, shakespeareCss, text
, transformers, unorderedContainers, wai, yesodCore, yesodForm
, yesodJson, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.1.0";
  sha256 = "1bvvd1fl2id7zw51g5mrm047zm2jy5hr5l1xxas6zin2dv0ix5p1";
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
