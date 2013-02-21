{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, fileEmbed
, hamlet, httpConduit, httpTypes, liftedBase, mimeMail, network
, persistent, persistentTemplate, pureMD5, pwstoreFast, random, SHA
, shakespeareCss, shakespeareJs, text, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodJson
, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.1.5.3";
  sha256 = "07srz4zpkn8w382xwi8ri6mh9kgplf0m51819zw1hympphmd9z82";
  buildDepends = [
    aeson authenticate blazeHtml blazeMarkup fileEmbed hamlet
    httpConduit httpTypes liftedBase mimeMail network persistent
    persistentTemplate pureMD5 pwstoreFast random SHA shakespeareCss
    shakespeareJs text transformers unorderedContainers wai yesodCore
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
