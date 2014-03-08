{ cabal, deepseq, hspec, text }:

cabal.mkDerivation (self: {
  pname = "text-stream-decode";
  version = "0.1.0.4";
  sha256 = "041winxbqkz1y6vx6sgbhl925n5qxii2q7ijcwa85sj4dkrqpafr";
  buildDepends = [ text ];
  testDepends = [ deepseq hspec text ];
  meta = {
    homepage = "http://github.com/fpco/text-stream-decode";
    description = "Streaming decoding functions for UTF encodings";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
