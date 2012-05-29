{ cabal, cmdargs, csv, filepath, HUnit, mtl, parsec, regexpr, safe
, shakespeareText, split, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.18";
  sha256 = "17dd8pbn5ly8rxy8yp8fz1j8m2zad9s190jzcpx9pdaw6vf2jskc";
  buildDepends = [
    cmdargs csv filepath HUnit mtl parsec regexpr safe shakespeareText
    split time utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "Core data types, parsers and utilities for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
