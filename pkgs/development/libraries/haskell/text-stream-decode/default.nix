{ cabal, deepseq, hspec, text }:

cabal.mkDerivation (self: {
  pname = "text-stream-decode";
  version = "0.1.0.3";
  sha256 = "0gz5w7n7yb6z5mfzlg3yg9s89wsqnmmk4j94invj2da0rw7d03xv";
  buildDepends = [ text ];
  testDepends = [ deepseq hspec text ];
  meta = {
    homepage = "http://github.com/fpco/text-stream-decode";
    description = "Streaming decoding functions for UTF encodings";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
