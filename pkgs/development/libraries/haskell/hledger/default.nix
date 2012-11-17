{ cabal, cmdargs, filepath, haskeline, hledgerLib, HUnit, mtl
, parsec, regexpr, safe, shakespeareText, split, text, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.19.1";
  sha256 = "0ad7wmcpwi7a9nag4j27rhffhai6a5zgzaafss7sfr7yia00cpgg";
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
