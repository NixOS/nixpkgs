{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "strptime";
  version = "1.0.7";
  sha256 = "1x8z7ib66v8xif7gxdzsxi7ifnz75f4k2c1h2jsjq308srdzxjcr";
  buildDepends = [ time ];
  meta = {
    description = "Efficient parsing of LocalTime using a binding to C's strptime, with some extra features (i.e. fractional seconds)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
