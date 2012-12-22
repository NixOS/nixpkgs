{ cabal, cmdargs, filepath, haskeline, hledgerLib, HUnit, mtl
, parsec, regexpr, safe, shakespeareText, split, text, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.19.3";
  sha256 = "1kxkv2dwl5ir2vqvbi1ppbwns8mw1lkg5lkfdkdwwbjj7dq0ysr6";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs filepath haskeline hledgerLib HUnit mtl parsec regexpr safe
    shakespeareText split text time utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "The main command-line interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
