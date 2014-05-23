{ cabal, async, blazeBuilder, deepseq, hspec, network, QuickCheck
, random, text, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.3";
  sha256 = "0zv309lqmv5bgbmxx5k0zk4iyxwj77lwqcaaycizi7559nzvsrh3";
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
