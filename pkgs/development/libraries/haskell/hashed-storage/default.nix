{cabal, mtl, zlib, mmap, binary, dataenc}:

cabal.mkDerivation (self : {
  pname = "hashed-storage";
  version = "0.5.3";
  sha256 = "0ql8hgsaazs0wxvr920vm2s2iljcnh6lnivcy3vgd5wjaw6lkd00";
  propagatedBuildInputs = [mtl zlib mmap binary dataenc];
  meta = {
    description = "Hashed file storage support code";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
