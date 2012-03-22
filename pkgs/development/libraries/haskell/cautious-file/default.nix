{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "cautious-file";
  version = "1.0.1";
  sha256 = "0mlgchvdhw9lhml4pqmxxvx1zcqmkcyl3yx6w3zp0df200njzsws";
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
