{ cabal, aeson, authenticate, blazeHtml, hamlet, httpConduit
, liftedBase, mimeMail, persistent, persistentTemplate, pureMD5
, pwstoreFast, random, SHA, shakespeareCss, text, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.0.2";
  sha256 = "1rbp62phyzlxm458xgqxg3qg5fvivmhcgzd8pprqy9ya0v58wwlr";
  buildDepends = [
    aeson authenticate blazeHtml hamlet httpConduit liftedBase mimeMail
    persistent persistentTemplate pureMD5 pwstoreFast random SHA
    shakespeareCss text transformers unorderedContainers wai yesodCore
    yesodForm yesodJson yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
