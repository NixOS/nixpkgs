{ cabal, comonad, contravariant, distributive, semigroupoids
, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonad-transformers";
  version = "3.1";
  sha256 = "024l437xfi0bkbn3121xi8slwsh9jby9a92qg1m5y0nmxzs9lxda";
  buildDepends = [
    comonad contravariant distributive semigroupoids semigroups
    transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/comonad-transformers/";
    description = "Comonad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
