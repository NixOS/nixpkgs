{ cabal, gloss, repa, llvm }:

cabal.mkDerivation (self: {
  pname = "gloss-raster";
  version = "1.8.1.1";
  sha256 = "0qqk2fizmv1zdvi8lljxiqdwlmfzni4qzsdvm2jbvgg5qjx9l9qp";
  buildDepends = [ gloss repa llvm ];
  meta = {
    homepage = "http://gloss.ouroborus.net";
    description = "Parallel rendering of raster images";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
