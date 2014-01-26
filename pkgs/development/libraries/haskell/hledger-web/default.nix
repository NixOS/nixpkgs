{ cabal, blazeHtml, blazeMarkup, clientsession, cmdargs
, dataDefault, filepath, hamlet, hjsmin, hledger, hledgerLib, hspec
, httpClient, httpConduit, HUnit, json, networkConduit, parsec
, regexpr, safe, shakespeareText, text, time, transformers, wai
, waiExtra, waiHandlerLaunch, warp, yaml, yesod, yesodCore
, yesodStatic, yesodTest
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.22.1";
  sha256 = "0nqw7scnhcip2bg832p9v0rqk01gn4xwj9bqsvsvmh31fh9ldchw";
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
  patchPhase = ''
    sed -i -e 's|blaze-html.*0.7|blaze-html|' -e 's|blaze-markup.*0.7|blaze-markup|' hledger-web.cabal
  '';
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
