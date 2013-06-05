{ cabal, blazeHtml, blazeMarkup, clientsession, cmdargs
, dataDefault, filepath, hamlet, hjsmin, hledger, hledgerLib, hspec
, httpConduit, HUnit, json, networkConduit, parsec, regexpr, safe
, shakespeareText, text, time, transformers, wai, waiExtra
, waiHandlerLaunch, warp, yaml, yesod, yesodCore, yesodPlatform
, yesodStatic, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.21.2";
  sha256 = "1z8nyvqzyjh36g50w4gmh8mzvydanfn1s3gx4nliwk4mjfj4bbkl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml blazeMarkup clientsession cmdargs dataDefault filepath
    hamlet hjsmin hledger hledgerLib httpConduit HUnit json
    networkConduit parsec regexpr safe shakespeareText text time
    transformers wai waiExtra waiHandlerLaunch warp yaml yesod
    yesodCore yesodPlatform yesodStatic
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
