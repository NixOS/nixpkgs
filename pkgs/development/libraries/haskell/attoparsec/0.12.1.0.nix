{ cabal, deepseq, QuickCheck, scientific, testFramework
, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.12.1.0";
  sha256 = "1y7sikk5hg9yj3mn21k026ni6lznsih0lx03rgdz4gmb6aqh54bn";
  buildDepends = [ deepseq scientific text ];
  testDepends = [
    deepseq QuickCheck scientific testFramework
    testFrameworkQuickcheck2 text
  ];
  meta = {
    homepage = "https://github.com/bos/attoparsec";
    description = "Fast combinator parsing for bytestrings and text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
