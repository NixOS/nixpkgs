{ cabal, deepseq, QuickCheck, scientific, testFramework
, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.11.2.1";
  sha256 = "1grvmhxiqn02wbng0wd9zqc4c51wrbxar1b26agc3p9i09ngbs1w";
  buildDepends = [ deepseq scientific text ];
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2 text
  ];
  meta = {
    homepage = "https://github.com/bos/attoparsec";
    description = "Fast combinator parsing for bytestrings and text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
