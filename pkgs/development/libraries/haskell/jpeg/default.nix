{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "jpeg";
  version = "0.0.1";
  sha256 = "848e047cfec5781a28f472e9cd27d016362211d88dd6adb4f826c37d29d8bba6";
  buildDepends = [ mtl ];
  meta = {
    description = "A library for decoding JPEG files written in pure Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
