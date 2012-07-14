{ cabal }:

cabal.mkDerivation (self: {
  pname = "binary";
  version = "0.5.1.1";
  sha256 = "0s62a92a2wwp8hdmkc6j6i9lh5mi6z1yd26fbhsbbm8bxah64pcl";
  meta = {
    homepage = "http://code.haskell.org/binary/";
    description = "Binary serialisation for Haskell values using lazy ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
