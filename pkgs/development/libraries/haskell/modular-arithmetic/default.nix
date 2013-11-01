{ cabal }:

cabal.mkDerivation (self: {
  pname = "modular-arithmetic";
  version = "1.1.0.0";
  sha256 = "02zxxz204ydyj28p65fqb920x5gbm7gba4yf9mhiw6ff0dcmxp37";
  meta = {
    description = "A type for integers modulo some constant";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
