{ cabal, async, HUnit, liftedBase, monadControl, mtl, tasty
, tastyHunit, tastyTh, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-async";
  version = "0.1.2";
  sha256 = "05ra09phkswxydr03f9xscrkxnv0yvp69376dl6lln7p5j45lmc3";
  buildDepends = [ async liftedBase monadControl transformersBase ];
  testDepends = [
    async HUnit liftedBase monadControl mtl tasty tastyHunit tastyTh
  ];
  meta = {
    homepage = "https://github.com/maoe/lifted-async";
    description = "Run lifted IO operations asynchronously and wait for their results";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
