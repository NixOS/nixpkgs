{ cabal, blazeBuilder, caseInsensitive, text }:

cabal.mkDerivation (self: {
  pname = "http-types";
  version = "0.7.2";
  sha256 = "06yvjq4246sp6gfillwbk6xz1d9l0zq06qy70a5zdyaw6viz2h76";
  buildDepends = [ blazeBuilder caseInsensitive text ];
  meta = {
    homepage = "https://github.com/aristidb/http-types";
    description = "Generic HTTP types for Haskell (for both client and server code)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
