{ cabal, cmdargs, HUnit, mtl, parsec, regexpr, safe, split, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.16";
  sha256 = "095hghg7b6x355yfd3xcp8cngl94k8qbl5x7qm12ncin9dsmz8h8";
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
