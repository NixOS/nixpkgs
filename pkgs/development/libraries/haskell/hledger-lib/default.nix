{ cabal, cmdargs, csv, filepath, HUnit, mtl, parsec, prettyShow
, regexCompat, regexpr, safe, split, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.20.0.1";
  sha256 = "1skm2jii7d8b6a6i98xwxckxwhikgj44823wqzdk8f3bq9zlwhcg";
  buildDepends = [
    cmdargs csv filepath HUnit mtl parsec prettyShow regexCompat
    regexpr safe split time transformers utf8String
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
