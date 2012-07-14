{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpu";
  version = "0.1.1";
  sha256 = "0ygkxx8ksa0rh63569d3g0w8pzgwg6062sd4yyi3q646zcmryhj6";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://github.com/vincenthz/hs-cpu";
    description = "Cpu information and properties helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
