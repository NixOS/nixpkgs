{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "strptime";
  version = "1.0.6";
  sha256 = "1brzh22nrs2mg5h815vj8vlz0qn2jwm4y4sdp5zlszjxfsqc2hp7";
  buildDepends = [ time ];
  meta = {
    description = "Efficient parsing of LocalTime using a binding to C's strptime, with some extra features (i.e. fractional seconds)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
