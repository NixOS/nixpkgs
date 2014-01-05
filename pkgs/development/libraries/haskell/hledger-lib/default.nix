{ cabal, cmdargs, csv, dataPprint, filepath, HUnit, mtl, parsec
, prettyShow, regexCompatTdfa, regexpr, safe, split, testFramework
, testFrameworkHunit, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.22";
  sha256 = "059dbwmafwy25pbr9311lknhyjlycdhhal4ng9i56bgd334l2wx3";
  buildDepends = [
    cmdargs csv dataPprint filepath HUnit mtl parsec prettyShow
    regexCompatTdfa regexpr safe split time transformers utf8String
  ];
  testDepends = [
    cmdargs csv dataPprint filepath HUnit mtl parsec prettyShow
    regexCompatTdfa regexpr safe split testFramework testFrameworkHunit
    time transformers
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
