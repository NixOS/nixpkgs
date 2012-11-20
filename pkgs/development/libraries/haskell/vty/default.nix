{ cabal, deepseq, mtl, parallel, parsec, terminfo, utf8String
, vector
}:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "4.7.0.20";
  sha256 = "15slw4zpvfkx9qwj2g5ndcxwbw0kkhyq8frvh9kharqd0zqzgqzb";
  buildDepends = [
    deepseq mtl parallel parsec terminfo utf8String vector
  ];
  meta = {
    homepage = "https://github.com/coreyoconnor/vty";
    description = "A simple terminal UI library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
