{ cabal, liftedBase, monadControl, mtl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.4.0.2";
  sha256 = "0w4hm29dig6m4jm6y9zmyfnhwii7b88hqjqlvl6xmk5zxp1q7hc2";
  buildDepends = [
    liftedBase monadControl mtl transformers transformersBase
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Deterministic allocation and freeing of scarce resources";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
