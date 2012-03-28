{ cabal }:

cabal.mkDerivation (self: {
  pname = "dataenc";
  version = "0.14.0.3";
  sha256 = "1k6k9cpx5ma32gvzf2mdbz4kfiblwfah9875qr13zkl4has9y0pd";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Library/Data_encoding";
    description = "Data encoding library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
