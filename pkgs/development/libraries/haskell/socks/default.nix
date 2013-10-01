{ cabal, cereal, network }:

cabal.mkDerivation (self: {
  pname = "socks";
  version = "0.5.2";
  sha256 = "1bvvrc0lzjspab7jn31d45za8g6n9jr52mcf7rs5zci99f5jgpsv";
  buildDepends = [ cereal network ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-socks";
    description = "Socks proxy (version 5) implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
