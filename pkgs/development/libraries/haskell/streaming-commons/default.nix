{ cabal, async, blazeBuilder, deepseq, hspec, network, QuickCheck
, text, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.2.2";
  sha256 = "0hk01cq39f6rwnj1qpikfyfbq8vayjmvl211b97rvv8ris5y90r4";
  buildDepends = [ blazeBuilder network text transformers zlib ];
  testDepends = [
    async blazeBuilder deepseq hspec network QuickCheck text zlib
  ];
  meta = {
    homepage = "https://github.com/fpco/streaming-commons";
    description = "Common lower-level functions needed by various streaming data libraries";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
