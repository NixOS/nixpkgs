{ cabal, baseUnicodeSymbols, dstring, random, stringCombinators }:

cabal.mkDerivation (self: {
  pname = "repr";
  version = "0.4.1.3";
  sha256 = "1y1zl81yjc9jrci83bm6bn8hrfqf6x25vxzkhrkydhhwcwqfqaj5";
  buildDepends = [
    baseUnicodeSymbols dstring random stringCombinators
  ];
  meta = {
    homepage = "https://github.com/basvandijk/repr";
    description = "Render overloaded expressions to their textual representation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
