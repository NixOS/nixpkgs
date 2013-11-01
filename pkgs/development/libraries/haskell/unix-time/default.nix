{ cabal, doctest, hspec, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "unix-time";
  version = "0.2.1";
  sha256 = "15kg1rxbw86p5jzig9ac7lsizmlvqkxikq7h8jfi04rri39a9jiy";
  testDepends = [ doctest hspec QuickCheck time ];
  meta = {
    description = "Unix time parser/formatter and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
