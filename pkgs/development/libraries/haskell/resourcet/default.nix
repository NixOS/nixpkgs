{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.4.8";
  sha256 = "10pp4hm5c2k2fqzqpagy03gmr526ac2ji8h7k0mcypf4v0ga620m";
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
