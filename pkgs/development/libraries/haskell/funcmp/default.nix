{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "funcmp";
  version = "1.6";
  sha256 = "1l317gnav6adbdi849zdcgcvrlcs4mz4p0s67wg323prq713fkz0";
  buildDepends = [ filepath ];
  meta = {
    homepage = "http://savannah.nongnu.org/projects/funcmp/";
    description = "Functional MetaPost";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
