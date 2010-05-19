{cabal, mtl, zlib, mmap, binary, dataenc}:

cabal.mkDerivation (self : {
  pname = "hashed-storage";
  version = "0.4.11";
  sha256 = "c719f9b86c5a517324ce3448fcb4b6377ccbfa085268b396bec47b8bbcfbde1b";
  propagatedBuildInputs = [mtl zlib mmap binary dataenc];
  meta = {
    description = "Hashed file storage support code";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

