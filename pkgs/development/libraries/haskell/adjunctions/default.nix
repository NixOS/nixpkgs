{ cabal, comonad, contravariant, distributive, free, mtl
, profunctors, semigroupoids, semigroups, tagged, transformers
, void
}:

cabal.mkDerivation (self: {
  pname = "adjunctions";
  version = "4.1.0.1";
  sha256 = "18p2pabid7dx96qcpd2ywv5mhjp55srhm5g013pn697jcxyq2xiv";
  buildDepends = [
    comonad contravariant distributive free mtl profunctors
    semigroupoids semigroups tagged transformers void
  ];
  meta = {
    homepage = "http://github.com/ekmett/adjunctions/";
    description = "Adjunctions and representable functors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
