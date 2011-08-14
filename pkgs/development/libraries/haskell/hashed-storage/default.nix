{ cabal, binary, dataenc, extensibleExceptions, mmap, mtl, zlib }:

cabal.mkDerivation (self: {
  pname = "hashed-storage";
  version = "0.5.8";
  sha256 = "1730hg6h7a1b0vgr9dvish41bpgly5cjpdwhqny75fi5in7dqplh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary dataenc extensibleExceptions mmap mtl zlib
  ];
  meta = {
    description = "Hashed file storage support code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
