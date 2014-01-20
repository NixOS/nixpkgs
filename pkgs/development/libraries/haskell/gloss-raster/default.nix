{ cabal, gloss, llvm, repa }:

cabal.mkDerivation (self: {
  pname = "gloss-raster";
  version = "1.8.1.2";
  sha256 = "1cpibilv027rfx7xz957f1d7wy6b5z6dgfjrw425ck497r8gfgp4";
  buildDepends = [ gloss repa ];
  extraLibraries = [ llvm ];
  meta = {
    homepage = "http://gloss.ouroborus.net";
    description = "Parallel rendering of raster images";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
