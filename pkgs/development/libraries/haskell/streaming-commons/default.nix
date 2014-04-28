{ cabal, async, blazeBuilder, deepseq, hspec, network, QuickCheck
, text, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "streaming-commons";
  version = "0.1.2";
  sha256 = "1n1gav19bc9ifgwhlz4qlrnpgq0fk4x98v6s19zxr88v89rlxdd7";
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
