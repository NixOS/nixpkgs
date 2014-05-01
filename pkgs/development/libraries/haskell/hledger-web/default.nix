{ cabal, blazeHtml, blazeMarkup, clientsession, cmdargs
, conduitExtra, dataDefault, filepath, hamlet, hjsmin, hledger
, hledgerLib, hspec, httpClient, httpConduit, HUnit, json
, networkConduit, parsec, regexpr, safe, shakespeare
, shakespeareText, text, time, transformers, wai, waiExtra
, waiHandlerLaunch, warp, yaml, yesod, yesodCore, yesodStatic
, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.22.8";
  sha256 = "0588r4hgy7800jla5jma96a7pmm64b116w6ffid9v5j52qjxyhf3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml blazeMarkup clientsession cmdargs conduitExtra
    dataDefault filepath hamlet hjsmin hledger hledgerLib httpClient
    httpConduit HUnit json networkConduit parsec regexpr safe
    shakespeare shakespeareText text time transformers wai waiExtra
    waiHandlerLaunch warp yaml yesod yesodCore yesodStatic
  ];
  testDepends = [ hspec yesod yesodTest ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
