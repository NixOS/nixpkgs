{ cabal, cmdargs, HUnit, mtl, parsec, regexpr, safe, split, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.16.1";
  sha256 = "15imhdkzfnxr72lsghrbsfisc7c2al4jkzcp72yf4hhra4zym1sd";
  buildDepends = [
    cmdargs HUnit mtl parsec regexpr safe split time utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "Core data types, parsers and utilities for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
