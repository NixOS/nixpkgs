{ cabal, cereal, deepseq, mtl, primitive, transformers, vector
, zlib
}:

cabal.mkDerivation (self: {
  pname = "JuicyPixels";
  version = "1.3";
  sha256 = "07wljfag4ylw16wdi7znjb61pfihdik5d7p4h2lmz6xirm4mjzrm";
  buildDepends = [
    cereal deepseq mtl primitive transformers vector zlib
  ];
  meta = {
    homepage = "https://github.com/Twinside/Juicy.Pixels";
    description = "Picture loading/serialization (in png, jpeg and bitmap)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
