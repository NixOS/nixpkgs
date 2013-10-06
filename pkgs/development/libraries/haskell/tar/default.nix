{ cabal, filepath, time }:

cabal.mkDerivation (self: {
  pname = "tar";
  version = "0.4.0.1";
  sha256 = "0vbsv7h3zgp30mlgsw156jkv1rqy5zbm98as9haf7x15hd6jf254";
  buildDepends = [ filepath time ];
  meta = {
    description = "Reading, writing and manipulating \".tar\" archive files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
