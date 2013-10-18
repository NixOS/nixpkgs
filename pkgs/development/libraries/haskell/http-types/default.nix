{ cabal, blazeBuilder, caseInsensitive, hspec, QuickCheck, text }:

cabal.mkDerivation (self: {
  pname = "http-types";
  version = "0.8.2";
  sha256 = "1536wpmicmq90qvnvcvq1dzk2vfhj7ls6hz4pqp0ll9aksk3msr1";
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
