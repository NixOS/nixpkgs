{ cabal, cmdargs, csv, haskeline, hledgerLib, HUnit, mtl, parsec
, regexpr, safe, split, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.16.1";
  sha256 = "182a5qlcxbh9q8hzrmgm99hcgvxjq8j5xq202iff14p1yqv0irs2";
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
