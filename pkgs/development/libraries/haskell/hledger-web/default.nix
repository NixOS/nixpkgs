{ cabal, blazeHtml, cabalFileTh, clientsession, cmdargs, filepath
, hamlet, hledger, hledgerLib, HUnit, ioStorage, networkConduit
, parsec, regexpr, safe, shakespeareText, text, time, transformers
, wai, waiExtra, warp, yaml, yesod, yesodCore, yesodDefault
, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.18.2";
  sha256 = "1bhah29why34qaiy7mgzpzjd5dm94izcf3jmgflix56gkgzk86p1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml cabalFileTh clientsession cmdargs filepath hamlet hledger
    hledgerLib HUnit ioStorage networkConduit parsec regexpr safe
    shakespeareText text time transformers wai waiExtra warp yaml yesod
    yesodCore yesodDefault yesodStatic
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "A web interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
