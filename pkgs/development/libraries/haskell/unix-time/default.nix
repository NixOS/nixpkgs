{ cabal, doctest, hspec, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "unix-time";
  version = "0.1.9";
  sha256 = "0z4761g7rkw771r9828h1l37pp3brrra9ihjg203h66jc1wlvb72";
  testDepends = [ doctest hspec QuickCheck time ];
  meta = {
    description = "Unix time parser/formatter and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
