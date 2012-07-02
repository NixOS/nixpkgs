{ cabal, blazeHtml, cabalFileTh, clientsession, cmdargs, filepath
, hamlet, hledger, hledgerLib, HUnit, ioStorage, networkConduit
, parsec, regexpr, safe, shakespeareText, text, time, transformers
, wai, waiExtra, warp, yaml, yesod, yesodCore, yesodDefault
, yesodStatic
}:

cabal.mkDerivation (self: {
  pname = "hledger-web";
  version = "0.18.1";
  sha256 = "1khjqqjjcwcymyh395rfc39wzybacw5n64wmj2sixyw0p1l4mwg7";
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
