{cabal, monadControl, transformers} :

cabal.mkDerivation (self : {
  pname = "pool";
  version = "0.1.0.4";
  sha256 = "11jsls81njkwhn48xdyrqydhr4yz82g7a6pji80ckplkdyycgx6p";
  propagatedBuildInputs = [ monadControl transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/pool";
    description = "Thread-safe resource pools.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
