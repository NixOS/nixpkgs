{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "bmp";
  version = "1.2.5.1";
  sha256 = "1q1g5p7kan9hqb4s50fz989c4p8vmfrs7qvwiqx9bcic8k7jqld4";
  buildDepends = [ binary ];
  jailbreak = true;
  meta = {
    homepage = "http://code.ouroborus.net/bmp";
    description = "Read and write uncompressed BMP image files";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
