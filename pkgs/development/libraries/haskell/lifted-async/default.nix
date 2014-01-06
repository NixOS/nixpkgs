{ cabal, async, HUnit, liftedBase, monadControl, mtl, tasty
, tastyHunit, tastyTh, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-async";
  version = "0.1.1";
  sha256 = "0hkqiplnvy14m881n4bzamvy1432bxy4k1j4rwl824w5fn2h5i74";
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
