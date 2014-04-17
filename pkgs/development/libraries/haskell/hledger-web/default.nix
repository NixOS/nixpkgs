{ cabal, blazeHtml, blazeMarkup, clientsession, cmdargs
, conduitExtra, dataDefault, filepath, hamlet, hjsmin, hledger
, hledgerLib, hspec, httpClient, httpConduit, HUnit, json
, networkConduit, parsec, regexpr, safe, shakespeareText, text
, time, transformers, wai, waiExtra, waiHandlerLaunch, warp, yaml
, yesod, yesodCore, yesodStatic, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.22.7";
  sha256 = "0dxlprmymspjwxdr9sig483y8azd7z42sv6k6r35m74z7naga68y";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml blazeMarkup clientsession cmdargs conduitExtra
    dataDefault filepath hamlet hjsmin hledger hledgerLib httpClient
    httpConduit HUnit json networkConduit parsec regexpr safe
    shakespeareText text time transformers wai waiExtra
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
