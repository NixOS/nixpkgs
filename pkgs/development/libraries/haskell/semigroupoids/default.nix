{ cabal, comonad, contravariant, distributive, semigroups
, transformers
}:

cabal.mkDerivation (self: {
  pname = "semigroupoids";
  version = "4.0.2.1";
  sha256 = "00ga4spbnvwnk7j4h7zjw3bkd98glaganhcwq947ffadc0nansb1";
  buildDepends = [
    comonad contravariant distributive semigroups transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/semigroupoids";
    description = "Semigroupoids: Category sans id";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
