{ cabal, baseUnicodeSymbols, monadControl, transformersBase }:

cabal.mkDerivation (self: {
  pname = "lifted-base";
  version = "0.1.2";
  sha256 = "0js94dlfy2wjl026jcj2l399ly4zgw0cgxkmil6lsm34gcy9vrvq";
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
