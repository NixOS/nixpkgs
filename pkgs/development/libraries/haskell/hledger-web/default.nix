{ cabal, aeson, blazeHtml, cabalFileTh, clientsession, cmdargs
, dataObject, dataObjectYaml, failure, fileEmbed, filepath, hamlet
, hledger, hledgerLib, httpEnumerator, HUnit, ioStorage, parsec
, regexpr, safe, shakespeareCss, shakespeareJs, shakespeareText
, text, time, tlsExtra, transformers, wai, waiExtra, warp, yesod
, yesodCore, yesodForm, yesodJson, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.17.1";
  sha256 = "0cix0k2skbrcbjhj876cx4mizjvkqnr91s092a3lg4rv40dhgwa9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson blazeHtml cabalFileTh clientsession cmdargs dataObject
    dataObjectYaml failure fileEmbed filepath hamlet hledger hledgerLib
    httpEnumerator HUnit ioStorage parsec regexpr safe shakespeareCss
    shakespeareJs shakespeareText text time tlsExtra transformers wai
    waiExtra warp yesod yesodCore yesodForm yesodJson yesodStatic
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
