{ cabal, binary, dataenc, extensibleExceptions, mmap, mtl, zlib }:

cabal.mkDerivation (self: {
  pname = "hashed-storage";
  version = "0.5.7";
  sha256 = "1zlb8zslhq0damsavq1h92cnhb979jdniv0ivsfwwdbsi02vkv03";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary dataenc extensibleExceptions mmap mtl zlib
  ];
  meta = {
    description = "Hashed file storage support code.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
