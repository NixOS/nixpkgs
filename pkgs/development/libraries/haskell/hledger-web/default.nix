{ cabal, aesonNative, blazeHtml, cabalFileTh, clientsession
, cmdargs, dataObject, dataObjectYaml, failure, fileEmbed, hamlet
, hledger, hledgerLib, HUnit, ioStorage, parsec, regexpr, safe
, shakespeareCss, shakespeareJs, shakespeareText, text, time
, transformers, wai, waiExtra, warp, yesod, yesodCore, yesodForm
, yesodJson, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.16.5";
  sha256 = "0gqhmyl62jkz156gypzxwj46xrh5as3wrvkwrg04wfmpqrac5n06";
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
