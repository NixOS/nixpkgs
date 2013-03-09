{ cabal, blazeBuilder, dateCache, filepath, hspec, text, unixTime
}:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "0.3.1";
  sha256 = "0sjn3vad0fbchv1fhap71wfnihlwnfhk6p9h9hpnbr0i4b32f1ks";
  buildDepends = [ blazeBuilder dateCache filepath text unixTime ];
  testDepends = [ hspec ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
