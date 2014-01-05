{ cabal, doctest, hspec, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "unix-time";
  version = "0.2.2";
  sha256 = "0xnl12mscc5nwjl9s2lx4xr8q8agzcpxh3bmxxidfjrg19drfwrm";
  testDepends = [ doctest hspec QuickCheck time ];
  meta = {
    description = "Unix time parser/formatter and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
