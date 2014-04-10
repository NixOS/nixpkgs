{ cabal, async, deepseq, hspec, network, QuickCheck, text
, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.1";
  sha256 = "1mzpdhdc5kq9pfpsjs6v1j1qa1pdj1ca4s32z4bjq751jayj6ds6";
  buildDepends = [ network text transformers zlib ];
  testDepends = [ async deepseq hspec network QuickCheck text zlib ];
  meta = {
    homepage = "https://github.com/fpco/streaming-commons";
    description = "Common lower-level functions needed by various streaming data libraries";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
