{ cabal }:

cabal.mkDerivation (self: {
  pname = "bktrees";
  version = "0.3.1";
  sha256 = "1d2iz48n0ayn0hi9xa110pxy1mv5a4m21rmbpvs6ki1a7cv4ghn9";
  meta = {
    description = "A set data structure with approximate searching";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
