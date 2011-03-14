{cabal, mtl, zlib, mmap, binary, dataenc}:

cabal.mkDerivation (self : {
  pname = "hashed-storage";
  version = "0.5.5";
  sha256 = "03wx21kgnvkny8b6fz86wg85pr2sxbm15ndznnpqjg5gf126n842";
  propagatedBuildInputs = [mtl zlib mmap binary dataenc];
  meta = {
    description = "Hashed file storage support code";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
