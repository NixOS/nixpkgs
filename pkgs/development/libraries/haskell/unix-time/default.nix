{ cabal, doctest, hspec, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "unix-time";
  version = "0.1.8";
  sha256 = "1s9r2i4hl7nm1f4zya03q0a2ayliby51caziz1w79schhplfa5sv";
  testDepends = [ doctest hspec QuickCheck time ];
  meta = {
    description = "Unix time parser/formatter and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
