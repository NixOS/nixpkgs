{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "strptime";
  version = "1.0.8";
  sha256 = "0cd4wzrg9zpnwrfpp6lxs1ib06h0fcsdqd3idsw663wr5lllfgdq";
  buildDepends = [ time ];
  meta = {
    description = "Efficient parsing of LocalTime using a binding to C's strptime, with some extra features (i.e. fractional seconds)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
