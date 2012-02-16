{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "cautious-file";
  version = "1.0";
  sha256 = "1s2la91vk9c99bj0ipzc4r6w81rcs4jfmn0xr1cgjab00bzj880q";
  buildDepends = [ filepath ];
  meta = {
    description = "Ways to write a file cautiously, to reduce the chances of problems such as data loss due to crashes or power failures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
