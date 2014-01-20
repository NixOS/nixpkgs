{ cabal, aeson, authenticate, blazeHtml, blazeMarkup, dataDefault
, emailValidate, fileEmbed, hamlet, httpConduit, httpTypes
, liftedBase, mimeMail, network, persistent, persistentTemplate
, pureMD5, pwstoreFast, random, resourcet, safe, SHA
, shakespeareCss, shakespeareJs, text, time, transformers
, unorderedContainers, wai, yesodCore, yesodForm, yesodPersistent
}:

cabal.mkDerivation (self: {
  pname = "yesod-auth";
  version = "1.2.5.3";
  sha256 = "0rpyx9p3si5453166v9paq18nz209w6lxz3hy5nxg1hyihwh8gy9";
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
