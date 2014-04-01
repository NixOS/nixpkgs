{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.4.10.2";
  sha256 = "0k0l4909b30hc2apxgzjz1rxbqqkhqnqchz53wi6zyhvbh46ffh6";
  buildDepends = [
    liftedBase mmorph monadControl mtl transformers transformersBase
  ];
  testDepends = [ hspec liftedBase transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Deterministic allocation and freeing of scarce resources";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
