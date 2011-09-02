{ cabal, cmdargs, HUnit, mtl, parsec, regexpr, safe, split, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.15";
  sha256 = "1bsn02pgz38ivk6z24niwab2ibmysngc1hghw5d5n2xa862ffrgb";
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
