{ cabal, blazeBuilder, caseInsensitive, hspec, QuickCheck, text }:

cabal.mkDerivation (self: {
  pname = "http-types";
  version = "0.8.3";
  sha256 = "02l1lhl2ajbm5f7zq363nlb21dpdg1m0qsy330arccmds7z9g7a2";
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
