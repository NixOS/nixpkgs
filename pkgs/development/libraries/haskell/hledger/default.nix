{ cabal, cmdargs, csv, haskeline, hledgerLib, HUnit, mtl, parsec
, regexpr, safe, split, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.15.2";
  sha256 = "0gja0jvr8v9s1608w45rg1dwhj48yls59shqcs4z936xdg69l42w";
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
