{ cabal, deepseq, hspec, network, QuickCheck, text, transformers
, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.0.2";
  sha256 = "1idlhvlv5pg20xq8h4rmphyflvpc9q88krwm498mh3s4983ik28c";
  buildDepends = [ network text transformers zlib ];
  testDepends = [ deepseq hspec QuickCheck text zlib ];
  meta = {
    homepage = "https://github.com/fpco/streaming-commons";
    description = "Common lower-level functions needed by various streaming data libraries";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
