{ cabal, gloss, llvm, repa }:

cabal.mkDerivation (self: {
  pname = "gloss-raster";
  version = "1.8.2.1";
  sha256 = "0ls8rlwrbpisrmq2xigf9926pak028dmld6shrblcmdbykaz55ha";
  buildDepends = [ gloss repa ];
  extraLibraries = [ llvm ];
  meta = {
    homepage = "http://gloss.ouroborus.net";
    description = "Parallel rendering of raster images";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
