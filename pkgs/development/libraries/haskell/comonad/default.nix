{ cabal, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "comonad";
  version = "3.0.0.1";
  sha256 = "03xslpfil96v1qgk2g29vi46mb7l0fafy446ng1p4xgq9ddb2yaz";
  buildDepends = [ semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/comonad/";
    description = "Haskell 98 compatible comonads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
