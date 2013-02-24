{ cabal, Cabal, deepseq, mtl, parallel, parsec, QuickCheck, random
, stringQq, terminfo, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "4.7.3";
  sha256 = "0x059mzw6v2xf92fdhy0ilyqbics2as6dqrdr6njpp0m6qykkybb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    deepseq mtl parallel parsec stringQq terminfo utf8String vector
  ];
  testDepends = [
    Cabal deepseq mtl parallel parsec QuickCheck random terminfo
    utf8String vector
  ];
  meta = {
    homepage = "https://github.com/coreyoconnor/vty";
    description = "A simple terminal UI library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
