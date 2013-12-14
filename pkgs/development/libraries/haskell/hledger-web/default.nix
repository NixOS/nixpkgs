{ cabal, blazeHtml, blazeMarkup, clientsession, cmdargs
, dataDefault, filepath, hamlet, hjsmin, hledger, hledgerLib, hspec
, httpClient, httpConduit, HUnit, json, networkConduit, parsec
, regexpr, safe, shakespeareText, text, time, transformers, wai
, waiExtra, waiHandlerLaunch, warp, yaml, yesod, yesodCore
, yesodStatic, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.22";
  sha256 = "0bd1cb6988ainkzi034a4g4xnslqc6djv74gbq58aaxjqn4m7m80";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml blazeMarkup clientsession cmdargs dataDefault filepath
    hamlet hjsmin hledger hledgerLib httpClient httpConduit HUnit json
    networkConduit parsec regexpr safe shakespeareText text time
    transformers wai waiExtra waiHandlerLaunch warp yaml yesod
    yesodCore yesodStatic
  ];
  testDepends = [ hspec yesod yesodTest ];
  doCheck = false;
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
