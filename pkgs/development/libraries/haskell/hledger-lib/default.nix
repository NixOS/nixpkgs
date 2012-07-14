{ cabal, cmdargs, csv, filepath, HUnit, mtl, parsec, regexpr, safe
, shakespeareText, split, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.18.2";
  sha256 = "0lcs58bdix4m7sslrdi38rqw5x5fb4ip0n5is0phxdrbp0nggd4z";
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
