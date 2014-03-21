{ cabal, blazeHtml, blazeMarkup, clientsession, cmdargs
, dataDefault, filepath, hamlet, hjsmin, hledger, hledgerLib, hspec
, httpClient, httpConduit, HUnit, json, networkConduit, parsec
, regexpr, safe, shakespeareText, text, time, transformers, wai
, waiExtra, waiHandlerLaunch, warp, yaml, yesod, yesodCore
, yesodStatic, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.22.4";
  sha256 = "07xz6ijg3nzzjair5gdjjryv5hs2rxws4maz22rrqnpf8wwjjc54";
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
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
