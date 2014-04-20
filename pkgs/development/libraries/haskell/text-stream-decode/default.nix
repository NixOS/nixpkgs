{ cabal, deepseq, hspec, text }:

cabal.mkDerivation (self: {
  pname = "text-stream-decode";
  version = "0.1.0.5";
  sha256 = "1s2lncs5k8rswg1bpf4vz5p1maj46bsgf7ar4lzcla9bf3f4bppy";
  buildDepends = [ text ];
  testDepends = [ deepseq hspec text ];
  meta = {
    homepage = "http://github.com/fpco/text-stream-decode";
    description = "Streaming decoding functions for UTF encodings. (deprecated)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
