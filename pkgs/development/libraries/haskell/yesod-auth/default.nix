{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, dataDefault
, emailValidate, fileEmbed, hamlet, httpConduit, httpTypes
, liftedBase, mimeMail, network, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, resourcet, SHA, shakespeareCss
, shakespeareJs, text, transformers, unorderedContainers, wai
, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.2.0.1";
  sha256 = "02nljkc12mgjhvkiv876w6w13q9s9iigya8v4jzj6myv48lainvd";
  buildDepends = [
    aeson authenticate blazeHtml blazeMarkup dataDefault emailValidate
    fileEmbed hamlet httpConduit httpTypes liftedBase mimeMail network
    persistent persistentTemplate pureMD5 pwstoreFast random resourcet
    SHA shakespeareCss shakespeareJs text transformers
    unorderedContainers wai yesodCore yesodForm yesodPersistent
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Authentication for Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
