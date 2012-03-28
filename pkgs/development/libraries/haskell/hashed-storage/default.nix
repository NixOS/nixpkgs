{ cabal, binary, dataenc, extensibleExceptions, filepath, mmap, mtl
, zlib
}:

cabal.mkDerivation (self: {
  pname = "hashed-storage";
  version = "0.5.9";
  sha256 = "1ycn0zwk5jqm6wwgs8nxpdg7fh5wx0i2058i0a924whj196kkhk2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary dataenc extensibleExceptions filepath mmap mtl zlib
  ];
  meta = {
    description = "Hashed file storage support code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
