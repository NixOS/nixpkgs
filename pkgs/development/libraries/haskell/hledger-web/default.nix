{ cabal, aesonNative, blazeHtml, clientsession, cmdargs, dataObject
, dataObjectYaml, failure, fileEmbed, hamlet, hledger, hledgerLib
, HUnit, ioStorage, parsec, regexpr, safe, shakespeareCss
, shakespeareJs, shakespeareText, text, time, transformers, wai
, waiExtra, warp, yesod, yesodCore, yesodForm, yesodJson
, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.16.3";
  sha256 = "0jciah0k6i4aa21hgpl1nqfyjkmm5kg5zmzmxwynvwckncy17ihg";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aesonNative blazeHtml clientsession cmdargs dataObject
    dataObjectYaml failure fileEmbed hamlet hledger hledgerLib HUnit
    ioStorage parsec regexpr safe shakespeareCss shakespeareJs
    shakespeareText text time transformers wai waiExtra warp yesod
    yesodCore yesodForm yesodJson yesodStatic
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
