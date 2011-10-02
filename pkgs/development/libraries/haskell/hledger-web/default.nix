{ cabal, aesonNative, blazeHtml, clientsession, cmdargs, dataObject
, dataObjectYaml, failure, fileEmbed, hamlet, hledger, hledgerLib
, HUnit, ioStorage, parsec, regexpr, safe, shakespeareCss
, shakespeareJs, shakespeareText, text, time, transformers, wai
, waiExtra, warp, yesod, yesodCore, yesodForm, yesodJson
, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.16";
  sha256 = "1564w1619s08q5c1zx8i8z488zis13a8d6n4cnyha9ci95p1c89j";
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
