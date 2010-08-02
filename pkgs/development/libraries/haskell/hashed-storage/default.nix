{cabal, mtl, zlib, mmap, binary, dataenc}:

cabal.mkDerivation (self : {
  pname = "hashed-storage";
  version = "0.4.13";
  sha256 = "c4e8dbd23469cde19696344f3e56088313ce5ee823e2d89ad2d0cb1fce602b63";
  propagatedBuildInputs = [mtl zlib mmap binary dataenc];
  meta = {
    description = "Hashed file storage support code";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
