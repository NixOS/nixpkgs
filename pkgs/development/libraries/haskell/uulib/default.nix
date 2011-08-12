{ cabal }:

cabal.mkDerivation (self: {
  pname = "uulib";
  version = "0.9.14";
  sha256 = "0bi62l9fp1ghqq4dagdy4nsxmm08gpsrnfgy6d6k8f4239s3yr0z";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Haskell Utrecht Tools Library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
