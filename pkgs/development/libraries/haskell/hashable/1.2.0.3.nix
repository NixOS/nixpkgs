{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "hashable";
  version = "1.2.0.3";
  sha256 = "0q4zl2mry6qfp9vln6pxmgqik7szv1sh7if55gydnxln1ybvvgmp";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/tibbe/hashable";
    description = "A class for types that can be converted to a hash value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
