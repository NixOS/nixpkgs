{ cabal, async, blazeBuilder, deepseq, hspec, network, QuickCheck
, text, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.2.3";
  sha256 = "1f8lngnxx0ml7bph8lfx3azv6fh6gwm86yhb8i5v9ghnflblaxxs";
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
