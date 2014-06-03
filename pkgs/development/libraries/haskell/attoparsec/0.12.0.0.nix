{ cabal, deepseq, QuickCheck, scientific, testFramework
, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.12.0.0";
  sha256 = "04wdb2i2yqybkfnjs3f25nf7xz1nq5sn8z23klbm4xnqaiajmkmr";
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
