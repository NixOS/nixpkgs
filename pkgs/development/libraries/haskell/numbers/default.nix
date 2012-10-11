{ cabal }:

cabal.mkDerivation (self: {
  pname = "numbers";
  version = "3000.1.0.0";
  sha256 = "0iqpch8j2i2pnjq8waqb5y95jpmvbzx2r6zsvkja7sl4d578fgpn";
  meta = {
    homepage = "https://github.com/DanBurton/numbers";
    description = "Various number types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
