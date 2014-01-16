{ cabal, deepseq, QuickCheck, scientific, testFramework
, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.11.1.0";
  sha256 = "09mks6lbzmqmdz6s10lvdklmc0mydd1sk5hphhnybp3yr4pvh7jc";
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
