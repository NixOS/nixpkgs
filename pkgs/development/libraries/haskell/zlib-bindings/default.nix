{ cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib-bindings";
  version = "0.1.0.1";
  sha256 = "0r1hjmmxb9kz5fvfrjvzjd0pnhb87vyldqvb73yjq35s16bj4vlc";
  buildDepends = [ zlib ];
  meta = {
    homepage = "http://github.com/snoyberg/zlib-bindings";
    description = "Low-level bindings to the zlib package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
