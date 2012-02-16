{ cabal, aeson, blazeHtml, Cabal, cabalFileTh, clientsession
, cmdargs, dataObject, dataObjectYaml, failure, fileEmbed, filepath
, hamlet, hledger, hledgerLib, HUnit, ioStorage, parsec, regexpr
, safe, shakespeareCss, shakespeareJs, shakespeareText, text, time
, transformers, wai, waiExtra, warp, yesod, yesodCore, yesodForm
, yesodJson, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.17";
  sha256 = "1b5k76p27pvxc91gns3aimy3zcy6m366nnpwzbm214v6ka82imfi";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson blazeHtml Cabal cabalFileTh clientsession cmdargs dataObject
    dataObjectYaml failure fileEmbed filepath hamlet hledger hledgerLib
    HUnit ioStorage parsec regexpr safe shakespeareCss shakespeareJs
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
