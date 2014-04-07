{ cabal, blazeBuilder, caseInsensitive, hspec, QuickCheck, text }:

cabal.mkDerivation (self: {
  pname = "http-types";
  version = "0.8.4";
  sha256 = "0bz7g537if863vk29z72hndf1x019dj7shj1aa77pssrxma3a685";
  buildDepends = [ blazeBuilder caseInsensitive text ];
  testDepends = [ blazeBuilder hspec QuickCheck text ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/aristidb/http-types";
    description = "Generic HTTP types for Haskell (for both client and server code)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
