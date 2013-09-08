{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, dataDefault
, emailValidate, fileEmbed, hamlet, httpConduit, httpTypes
, liftedBase, mimeMail, network, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, resourcet, safe, SHA
, shakespeareCss, shakespeareJs, text, time, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.2.2.1";
  sha256 = "1f3zdqywak54f2s11v26iyzb3svb0mdpfskxhps30jmkji2ph2iz";
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
