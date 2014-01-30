{ cabal, binary, deepseq, mtl, primitive, transformers, vector
, zlib
}:

cabal.mkDerivation (self: {
  pname = "JuicyPixels";
  version = "3.1.3.2";
  sha256 = "0c0vavqisljsl8v8hvmxj8q3hmjq5layanbbyp0zcbj6yxv8s62a";
  buildDepends = [
    binary deepseq mtl primitive transformers vector zlib
  ];
  meta = {
    homepage = "https://github.com/Twinside/Juicy.Pixels";
    description = "Picture loading/serialization (in png, jpeg, bitmap, gif, tiff and radiance)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
