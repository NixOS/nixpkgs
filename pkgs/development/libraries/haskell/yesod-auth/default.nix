{ cabal, aeson, authenticate, blazeHtml, Cabal, hamlet, httpConduit
, liftedBase, mimeMail, persistent, persistentTemplate, pureMD5
, pwstoreFast, random, SHA, shakespeareCss, text, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "0.8.1.1";
  sha256 = "0wmvywyil6cnpxq777a0w4qknw4lr4i53nni4bcigrvmpg7gzgac";
  buildDepends = [
    aeson authenticate blazeHtml Cabal hamlet httpConduit liftedBase
    mimeMail persistent persistentTemplate pureMD5 pwstoreFast random
    SHA shakespeareCss text transformers unorderedContainers wai
    yesodCore yesodForm yesodJson yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
