{ cabal, cmdargs, csv, filepath, HUnit, mtl, parsec, regexpr, safe
, split, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.19.3";
  sha256 = "1wn72ycy1hvcn2ikaplq446hggpkbabyj1d8201vajwn862waxra";
  buildDepends = [
    cmdargs csv filepath HUnit mtl parsec regexpr safe split time
    transformers utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "Core data types, parsers and utilities for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
