{ cabal, cmdargs, csv, filepath, HUnit, mtl, parsec, regexpr, safe
, shakespeareText, split, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.19";
  sha256 = "1kbjal838b3k0rmvdrndmyjngvyfwpmzh6y8kir4l2nf31jxwjbs";
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
