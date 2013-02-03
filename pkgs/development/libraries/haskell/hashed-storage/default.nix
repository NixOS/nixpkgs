{ cabal, binary, dataenc, extensibleExceptions, filepath, mmap, mtl
, zlib
}:

cabal.mkDerivation (self: {
  pname = "hashed-storage";
  version = "0.5.10";
  sha256 = "1k7drnk0y5apjvwsiw85032yvxllbi7ndg6h9x207gnjxm64m0h5";
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
