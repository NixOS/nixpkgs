{ cabal }:

cabal.mkDerivation (self: {
  pname = "bitmap";
  version = "0.0.1";
  sha256 = "281ad4d9234349cfd14f91977b48e2d1861c037f4b6562aa138cddd25c801a7e";
  meta = {
    homepage = "http://code.haskell.org/~bkomuves/";
    description = "A library for handling and manipulating bitmaps";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
