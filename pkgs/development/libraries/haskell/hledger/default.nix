{ cabal, cabalFileTh, cmdargs, filepath, haskeline, hledgerLib
, HUnit, mtl, parsec, regexpr, safe, shakespeareText, split, text
, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.18.1";
  sha256 = "0nrs9qawvny6dl0pj3f183sgwmam9dsb2dfhp8hqnxx48g1p01lk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cabalFileTh cmdargs filepath haskeline hledgerLib HUnit mtl parsec
    regexpr safe shakespeareText split text time utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "The main command-line interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
