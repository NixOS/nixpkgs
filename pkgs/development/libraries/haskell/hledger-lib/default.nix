{ cabal, cmdargs, HUnit, mtl, parsec, regexpr, safe, split, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.15.2";
  sha256 = "1if20197nyg1as6v1c4a0js694zg213nf7rhfhv2a46af58n0bgq";
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
