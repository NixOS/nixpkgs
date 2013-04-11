{ cabal }:

cabal.mkDerivation (self: {
  pname = "byteorder";
  version = "1.0.3";
  sha256 = "056jb47r4pkimi6z2z49prnsmjnhnijk57zm0divl1k55igi5way";
  meta = {
    homepage = "http://community.haskell.org/~aslatter/code/byteorder";
    description = "Exposes the native endianness or byte ordering of the system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
