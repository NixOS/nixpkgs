{ cabal, doctest, hspec, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "unix-time";
  version = "0.2.0";
  sha256 = "1gmchi6crbd3lpnw1j0zaaj7y0gib8dbqd8ip2s5p3f50qqlsxj8";
  testDepends = [ doctest hspec QuickCheck time ];
  meta = {
    description = "Unix time parser/formatter and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
