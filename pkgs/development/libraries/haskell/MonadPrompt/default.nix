{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "MonadPrompt";
  version = "1.0.0.3";
  sha256 = "0v6svyiajri7c463bz1a1x1nin5s9s7c3s7y0gjc4cn7lhgdsvf2";
  buildDepends = [ mtl ];
  meta = {
    description = "MonadPrompt, implementation & examples";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
