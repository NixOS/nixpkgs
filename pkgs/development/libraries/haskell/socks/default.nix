{ cabal, cereal, network }:

cabal.mkDerivation (self: {
  pname = "socks";
  version = "0.5.0";
  sha256 = "1lk6yvx5a65nz7z89i0sgqzcqw2v6j645nq15kgbpxhcinfdvqs7";
  buildDepends = [ cereal network ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-socks";
    description = "Socks proxy (version 5) implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
