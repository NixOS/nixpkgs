{ cabal, binary, doctest, hspec, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "unix-time";
  version = "0.3.1";
  sha256 = "1r7glbcr3108zrlpy2d09jyk1gv9k90d5saajipmb1f5l45rdhnj";
  buildDepends = [ binary ];
  testDepends = [ doctest hspec QuickCheck time ];
  meta = {
    description = "Unix time parser/formatter and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
