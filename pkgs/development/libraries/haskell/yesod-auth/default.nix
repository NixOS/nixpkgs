{ cabal, aeson, authenticate, blazeHtml, hamlet, httpConduit
, liftedBase, mimeMail, persistent, persistentTemplate, pureMD5
, pwstoreFast, random, SHA, shakespeareCss, text, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "0.8.1";
  sha256 = "10jhvkyxf8j55yzc05p0fmmjsd8fb1sns86vlsl0108947b2pp8v";
  buildDepends = [
    aeson authenticate blazeHtml hamlet httpConduit liftedBase mimeMail
    persistent persistentTemplate pureMD5 pwstoreFast random SHA
    shakespeareCss text transformers unorderedContainers wai yesodCore
    yesodForm yesodJson yesodPersistent
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
