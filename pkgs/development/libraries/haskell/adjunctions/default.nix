{ cabal, comonad, contravariant, distributive, free, mtl
, semigroupoids, semigroups, tagged, transformers, void
}:

cabal.mkDerivation (self: {
  pname = "adjunctions";
  version = "4.0.2";
  sha256 = "0c9168jmnfpzv3025n05b80b9p7jzkdzs0hzymjmh1qvz3iximq5";
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
