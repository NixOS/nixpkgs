{cabal, binary, dataenc, mmap, mtl, zlib} :

cabal.mkDerivation (self : {
  pname = "hashed-storage";
  version = "0.5.7";
  sha256 = "1zlb8zslhq0damsavq1h92cnhb979jdniv0ivsfwwdbsi02vkv03";
  propagatedBuildInputs = [ binary dataenc mmap mtl zlib ];
  meta = {
    description = "Hashed file storage support code.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
