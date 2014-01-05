{ cabal, binary, deepseq, mtl, primitive, transformers, vector
, zlib
}:

cabal.mkDerivation (self: {
  pname = "JuicyPixels";
  version = "3.1.2";
  sha256 = "19bal3g3cp4nn8g3zp4yi5g4zw5wnkbi74gcra8mxs4zy99bf8s2";
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
