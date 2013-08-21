{ cabal, blazeHtml, blazeMarkup, clientsession, cmdargs
, dataDefault, filepath, hamlet, hjsmin, hledger, hledgerLib, hspec
, httpConduit, HUnit, json, networkConduit, parsec, regexpr, safe
, shakespeareText, text, time, transformers, wai, waiExtra
, waiHandlerLaunch, warp, yaml, yesod, yesodCore, yesodStatic
, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.21.3";
  sha256 = "18gil6qwlzfk0y0f9q1la5np5phi0h3nqlb8rwn9qjjgvs134jgy";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml blazeMarkup clientsession cmdargs dataDefault filepath
    hamlet hjsmin hledger hledgerLib httpConduit HUnit json
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
