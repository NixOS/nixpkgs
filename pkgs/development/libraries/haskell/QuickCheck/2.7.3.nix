{ cabal, random, testFramework, tfRandom }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.7.3";
  sha256 = "196pz0b32m84ydwm4wk7m8512bmsxw7nsqpxbyfxsyi3ykq220yh";
  buildDepends = [ random tfRandom ];
  testDepends = [ testFramework ];
  meta = {
    homepage = "http://code.haskell.org/QuickCheck";
    description = "Automatic testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
