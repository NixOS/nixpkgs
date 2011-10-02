{ cabal, cmdargs, csv, haskeline, hledgerLib, HUnit, mtl, parsec
, regexpr, safe, split, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.16";
  sha256 = "0wz4g67ilxj741j8d7amssa6dr0xrdfghwmhzwlcp1fj4a5a44c8";
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
