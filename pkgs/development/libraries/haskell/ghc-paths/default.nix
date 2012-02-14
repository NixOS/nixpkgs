{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "ghc-paths";
  version = "0.1.0.8";
  sha256 = "0mhc5zhbybp1vmkjsqbca51993vkpx5g8hql160m8m95apkc2wl6";
  buildDepends = [ Cabal ];
  meta = {
    description = "Knowledge of GHC's installation directories";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
