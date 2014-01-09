{ cabal, blazeBuilder, filepath, hspec, text }:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "2.1.2";
  sha256 = "0kz31jfhc40wlw3b49zcsn97y6vc9qqnaci743mgjskv4zbqaf34";
  buildDepends = [ blazeBuilder filepath text ];
  testDepends = [ hspec ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
