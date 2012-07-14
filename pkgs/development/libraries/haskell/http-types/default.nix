{ cabal, blazeBuilder, caseInsensitive, text }:

cabal.mkDerivation (self: {
  pname = "http-types";
  version = "0.6.11";
  sha256 = "1waxhicqwp0nmvmpmfadpq9gdldbcx9wh6jz717ghi6y9l485vhf";
  buildDepends = [ blazeBuilder caseInsensitive text ];
  meta = {
    homepage = "https://github.com/aristidb/http-types";
    description = "Generic HTTP types for Haskell (for both client and server code)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
