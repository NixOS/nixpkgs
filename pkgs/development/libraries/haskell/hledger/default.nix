{ cabal, cmdargs, csv, haskeline, hledgerLib, HUnit, mtl, parsec
, regexpr, safe, split, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.15.1";
  sha256 = "0lm7w0r1pcv6jqpl2h1jcn77bqc6ld1z35zh30vbwgyj7mv02bdb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs csv haskeline hledgerLib HUnit mtl parsec regexpr safe
    split time utf8String
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
