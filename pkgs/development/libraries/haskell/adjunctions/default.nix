{ cabal, comonad, contravariant, distributive, free, mtl
, semigroupoids, semigroups, tagged, transformers, void
}:

cabal.mkDerivation (self: {
  pname = "adjunctions";
  version = "4.0.3";
  sha256 = "0rh3vffbq407k9g95dingw6zqq3fk87pknyrqj1mrbmgrnllr8k0";
  buildDepends = [
    comonad contravariant distributive free mtl semigroupoids
    semigroups tagged transformers void
  ];
  meta = {
    homepage = "http://github.com/ekmett/adjunctions/";
    description = "Adjunctions and representable functors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
