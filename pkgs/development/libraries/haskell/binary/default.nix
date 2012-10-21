{ cabal }:

cabal.mkDerivation (self: {
  pname = "binary";
  version = "0.6.2.0";
  sha256 = "0nm4vsgyz7ml6w3lk5hrh34i7s7li32gj7bgs75w636kln338aab";
  meta = {
    homepage = "https://github.com/kolmodin/binary";
    description = "Binary serialisation for Haskell values using lazy ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
