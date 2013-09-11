{ cabal, blazeBuilder, caseInsensitive, hspec, QuickCheck, text }:

cabal.mkDerivation (self: {
  pname = "http-types";
  version = "0.8.1";
  sha256 = "07hxxlhgnwsvjr2dzqbswwwkjxwsc0pk6shpkvzgclrsyn3xrg7p";
  buildDepends = [ blazeBuilder caseInsensitive text ];
  testDepends = [ blazeBuilder hspec QuickCheck text ];
  meta = {
    homepage = "https://github.com/aristidb/http-types";
    description = "Generic HTTP types for Haskell (for both client and server code)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
