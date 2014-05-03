{ cabal, deepseq, QuickCheck, scientific, testFramework
, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.11.3.0";
  sha256 = "1vnkm5pf0a381is4i0zyi41p4jv184lqpv1z9aadsnavpg0841qs";
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
