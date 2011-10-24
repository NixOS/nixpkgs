{ cabal, aesonNative, blazeHtml, cabalFileTh, clientsession
, cmdargs, dataObject, dataObjectYaml, failure, fileEmbed, hamlet
, hledger, hledgerLib, HUnit, ioStorage, parsec, regexpr, safe
, shakespeareCss, shakespeareJs, shakespeareText, text, time
, transformers, wai, waiExtra, warp, yesod, yesodCore, yesodForm
, yesodJson, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.16.4";
  sha256 = "1p776fzgan9y7g03g92gsvnassc3k28l6l3gr1vd9v3fcnckg2wj";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aesonNative blazeHtml cabalFileTh clientsession cmdargs dataObject
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
