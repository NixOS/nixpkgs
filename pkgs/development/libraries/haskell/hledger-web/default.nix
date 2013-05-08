{ cabal, blazeHtml, blazeMarkup, clientsession, cmdargs
, dataDefault, filepath, hamlet, hjsmin, hledger, hledgerLib
, httpConduit, HUnit, monadControl, networkConduit, parsec, regexpr
, safe, shakespeareCss, shakespeareJs, shakespeareText, text, time
, transformers, wai, waiExtra, waiHandlerLaunch, warp, yaml, yesod
, yesodCore, yesodDefault, yesodForm, yesodStatic, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.20.0.1";
  sha256 = "0fq3wfsy2ykyplr66ac91yd2vwzfw3ji8mq9q4jn58nnh6bgxfa1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml blazeMarkup clientsession cmdargs dataDefault filepath
    hamlet hjsmin hledger hledgerLib httpConduit HUnit monadControl
    networkConduit parsec regexpr safe shakespeareCss shakespeareJs
    shakespeareText text time transformers wai waiExtra
    waiHandlerLaunch warp yaml yesod yesodCore yesodDefault yesodForm
    yesodStatic
  ];
  testDepends = [ yesodCore yesodDefault yesodTest ];
  doCheck = false;
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
