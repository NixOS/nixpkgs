{ cabal, blazeBuilder, dateCache, filepath, hspec, text, unixTime
}:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "0.3.3";
  sha256 = "0ya9dn9j2nddpclj00w6jgmiq2xx500sws056fa2s4bdsl8vn5rh";
  buildDepends = [ blazeBuilder dateCache filepath text unixTime ];
  testDepends = [ hspec ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
