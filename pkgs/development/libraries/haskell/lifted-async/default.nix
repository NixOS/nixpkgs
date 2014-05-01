{ cabal, async, HUnit, liftedBase, monadControl, mtl, tasty
, tastyHunit, tastyTh, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-async";
  version = "0.2.0";
  sha256 = "1s8gz630v9xag0d5pjjwvfff87wvyy1w86ah7mvnylkarbdsac6l";
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
