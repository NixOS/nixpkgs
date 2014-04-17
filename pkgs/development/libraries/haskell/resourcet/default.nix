{ cabal, exceptions, hspec, liftedBase, mmorph, monadControl, mtl
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "1.1.2";
  sha256 = "1hm53zq61m1va9djxy0vi3nwdl4qz26dzk8a55qh40cpkf45zggk";
  buildDepends = [
    exceptions liftedBase mmorph monadControl mtl transformers
    transformersBase
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
