{ cabal, cmdargs, csv, filepath, HUnit, mtl, parsec, regexpr, safe
, shakespeareText, split, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.18.1";
  sha256 = "0dv5q20n5almxxl0n68lv1172x61z2q16nvwydzrc7qp1j31d8my";
  buildDepends = [
    cmdargs csv filepath HUnit mtl parsec regexpr safe shakespeareText
    split time transformers utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "Core data types, parsers and utilities for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
