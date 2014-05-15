{ cabal, async, blazeBuilder, deepseq, hspec, network, QuickCheck
, random, text, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.2.4";
  sha256 = "1wy1cdmx3fhxg9xb7v5r3nyyjhr7irvcwy3l4g6br671zh8j8kcg";
  buildDepends = [
    blazeBuilder network random text transformers zlib
  ];
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
