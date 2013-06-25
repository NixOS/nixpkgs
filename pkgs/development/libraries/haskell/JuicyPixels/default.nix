{ cabal, binary, deepseq, mmap, mtl, primitive, transformers
, vector, zlib
}:

cabal.mkDerivation (self: {
  pname = "JuicyPixels";
  version = "3.1";
  sha256 = "1z3adva85qgdyx85hldqi99lnb3pg7a42q44zxil4gxwi62pw4xr";
  buildDepends = [
    binary deepseq mmap mtl primitive transformers vector zlib
  ];
  meta = {
    homepage = "https://github.com/Twinside/Juicy.Pixels";
    description = "Picture loading/serialization (in png, jpeg, bitmap, gif, tiff and radiance)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
