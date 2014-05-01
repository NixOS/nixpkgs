{ cabal, async, blazeBuilder, deepseq, hspec, network, QuickCheck
, text, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.2.1";
  sha256 = "1skixb3cc47sfnq9w6r1qdw6d78wirrv4llrwikih0w7h0i8aqmx";
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
