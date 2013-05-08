{ cabal, cmdargs, filepath, haskeline, hledgerLib, HUnit, mtl
, parsec, regexpr, safe, shakespeareText, split, text, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.20.0.1";
  sha256 = "0sdsxdydpmnarxz94py8rlbcffpan7l299ff7j9gn4f42z3sarw7";
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
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
