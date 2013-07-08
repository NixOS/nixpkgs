{ cabal, doctest, filepath, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "comonad";
  version = "3.0.3";
  sha256 = "1wngwa1cdww5c631dcil0c7mgkqx9bj7m5i63p7d9ymhpyx9sw2l";
  buildDepends = [ semigroups transformers ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/comonad/";
    description = "Haskell 98 compatible comonads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
