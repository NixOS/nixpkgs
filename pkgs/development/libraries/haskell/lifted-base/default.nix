{ cabal, baseUnicodeSymbols, monadControl, transformersBase }:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.1.0.3";
  sha256 = "1fk2jv8xwjb4xmzcx7h74nh14i3wf5mpifiki9rvq4hnrb7gdx36";
  buildDepends = [
    baseUnicodeSymbols monadControl transformersBase
  ];
  meta = {
    homepage = "https://github.com/basvandijk/lifted-base";
    description = "lifted IO operations from the base library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
