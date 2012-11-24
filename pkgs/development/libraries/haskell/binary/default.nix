{ cabal }:

cabal.mkDerivation (self: {
  pname = "binary";
  version = "0.6.3.0";
  sha256 = "0gynhyamhvffy2z88xzi56kf57pd5d6534n7w0m11qq4188w0zai";
  meta = {
    homepage = "https://github.com/kolmodin/binary";
    description = "Binary serialisation for Haskell values using lazy ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
