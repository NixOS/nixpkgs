{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, dataDefault
, emailValidate, fileEmbed, hamlet, httpConduit, httpTypes
, liftedBase, mimeMail, network, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, resourcet, safe, SHA
, shakespeareCss, shakespeareJs, text, time, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.2.7";
  sha256 = "0arszd7nk7rwm0xnjb2vqk2zf7lcwyw1ncxyxdmdxxvmh28lymwk";
  buildDepends = [
    aeson authenticate blazeHtml blazeMarkup dataDefault emailValidate
    fileEmbed hamlet httpConduit httpTypes liftedBase mimeMail network
    persistent persistentTemplate pureMD5 pwstoreFast random resourcet
    safe SHA shakespeareCss shakespeareJs text time transformers
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
