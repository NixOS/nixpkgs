{ cabal, comonad, contravariant, distributive, semigroupoids
, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonad-transformers";
  version = "2.1.2";
  sha256 = "0yhpsifnqxrg1p8f9hjslwkrakiaxa2kk9726q923a5sj225cvis";
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
