{ cabal, comonad, contravariant, distributive, semigroups
, transformers
}:

cabal.mkDerivation (self: {
  pname = "semigroupoids";
  version = "4.0";
  sha256 = "12h2b9pisy21xca3x9ilj0aix9clni0za35d2dmv55gb8y8df54l";
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
