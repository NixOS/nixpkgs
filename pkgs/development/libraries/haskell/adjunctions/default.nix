{ cabal, comonad, contravariant, distributive, free, mtl
, semigroupoids, semigroups, tagged, transformers, void
}:

cabal.mkDerivation (self: {
  pname = "adjunctions";
  version = "4.0.1";
  sha256 = "0z13rmh9yp8jg2jzj3bmysqc4h2nblshx125h2sx51wllnvxzh5l";
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
