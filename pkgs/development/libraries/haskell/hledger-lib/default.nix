{ cabal, cmdargs, csv, filepath, HUnit, mtl, parsec, regexpr, safe
, shakespeareText, split, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.19.1";
  sha256 = "19ccbf9g1garwg56ig4qckz1zky89g1z71nwfbwi4v57bjw53ab4";
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
