{ cabal, baseUnicodeSymbols, monadControl, transformersBase }:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.1.0.2";
  sha256 = "1j810pdkhl6kpc368081ar1k9342k3bl4cmx294zdyd0j00n23zx";
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
