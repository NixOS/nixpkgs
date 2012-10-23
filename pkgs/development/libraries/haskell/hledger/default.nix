{ cabal, cmdargs, filepath, haskeline, hledgerLib, HUnit, mtl
, parsec, regexpr, safe, shakespeareText, split, text, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.19";
  sha256 = "0pl280vlwwsnl3grsbl5yv8kli1prkswa0p9j2s13g8m89srd1vf";
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
