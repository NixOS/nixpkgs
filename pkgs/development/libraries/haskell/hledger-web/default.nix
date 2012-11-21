{ cabal, blazeHtml, blazeMarkup, clientsession, cmdargs
, dataDefault, filepath, hamlet, hjsmin, hledger, hledgerLib
, httpConduit, HUnit, ioStorage, monadControl, networkConduit
, parsec, regexpr, safe, shakespeareCss, shakespeareJs
, shakespeareText, text, time, transformers, wai, waiExtra, warp
, yaml, yesod, yesodCore, yesodDefault, yesodForm, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.19";
  sha256 = "0p820pwx4javzfvzhz02930adx6w7246hdk802wz1g4937rlq8p3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml blazeMarkup clientsession cmdargs dataDefault filepath
    hamlet hjsmin hledger hledgerLib httpConduit HUnit ioStorage
    monadControl networkConduit parsec regexpr safe shakespeareCss
    shakespeareJs shakespeareText text time transformers wai waiExtra
    warp yaml yesod yesodCore yesodDefault yesodForm yesodStatic
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
