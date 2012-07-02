{ cabal, baseUnicodeSymbols, monadControl, transformersBase }:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.1.1.1";
  sha256 = "1cfk3n12qhyrrfvw410gfydbgmb7r9y65fsjp2r3c4ilcyd5li70";
  buildDepends = [
    baseUnicodeSymbols monadControl transformersBase
  ];
  meta = {
    homepage = "https://github.com/basvandijk/lifted-base";
    description = "lifted IO operations from the base library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
