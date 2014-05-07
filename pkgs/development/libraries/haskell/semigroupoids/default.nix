{ cabal, comonad, contravariant, distributive, semigroups
, transformers
}:

cabal.mkDerivation (self: {
  pname = "semigroupoids";
  version = "4.0.2";
  sha256 = "07xzqqdra2d5jr4wclislj1lhbb1nlry65m0y42hdxsjf3n05931";
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
