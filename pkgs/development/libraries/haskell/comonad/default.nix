{ cabal, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "comonad";
  version = "3.0.0.2";
  sha256 = "01q71b446mdbdj81qjrxjl5bshbg4bjih5zpw9fd4y5431bclfhi";
  buildDepends = [ semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/comonad/";
    description = "Haskell 98 compatible comonads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
