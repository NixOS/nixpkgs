{cabal, binary}:

cabal.mkDerivation (self : {
  pname = "bmp";
  version = "1.1.1.2";
  sha256 = "1hxsl9gip5icjbmr5y48nkb10csqwzcswssqfaq6cqwnfhpi7813";
  propagatedBuildInputs = [binary];
  meta = {
    description = "Read and write uncompressed BMP image files";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

