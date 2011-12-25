{ cabal, baseUnicodeSymbols, dstring, random, stringCombinators }:

cabal.mkDerivation (self: {
  pname = "repr";
  version = "0.4.1.2";
  sha256 = "09rv23p1hvvfw5wnhiawgrpqgqa4i0d00skyj9z1jj6bfxk5avjs";
  buildDepends = [
    baseUnicodeSymbols dstring random stringCombinators
  ];
  meta = {
    homepage = "https://github.com/basvandijk/repr";
    description = "Render overloaded expressions to their textual representation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
