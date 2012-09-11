{ cabal }:

cabal.mkDerivation (self: {
  pname = "numbers";
  version = "3000.0.0.0";
  sha256 = "073xjrnbv6z16va2h3arlxq3z8kywb961dwh4jcm8g7w5m84b2xb";
  meta = {
    homepage = "https://github.com/DanBurton/numbers";
    description = "Various number types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
