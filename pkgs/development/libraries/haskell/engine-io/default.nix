{ cabal, aeson, async, attoparsec, base64Bytestring, either
, monadLoops, mwcRandom, stm, text, transformers
, unorderedContainers, vector, websockets
}:

cabal.mkDerivation (self: {
  pname = "engine-io";
  version = "1.0.0";
  sha256 = "08gxhf9ihz32z5ayabxw7mn14rib2kyawrvfqzbdkw8vxgjiasv9";
  buildDepends = [
    aeson async attoparsec base64Bytestring either monadLoops mwcRandom
    stm text transformers unorderedContainers vector websockets
  ];
  meta = {
    homepage = "http://github.com/ocharles/engine.io";
    description = "A Haskell implementation of Engine.IO";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
