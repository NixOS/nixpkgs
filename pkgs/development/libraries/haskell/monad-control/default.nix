{ cabal, baseUnicodeSymbols, transformers, transformersBase }:

cabal.mkDerivation (self: {
  pname = "monad-control";
  version = "0.3.0.1";
  sha256 = "0aa73cw82yssias0a9y237h9r4v4abvs0lv2lmhxaa4a4mdrj3ms";
  buildDepends = [
    baseUnicodeSymbols transformers transformersBase
  ];
  meta = {
    homepage = "https://github.com/basvandijk/monad-control";
    description = "Lift control operations, like exception catching, through monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
