{ cabal, blazeBuilder, caseInsensitive, text }:

cabal.mkDerivation (self: {
  pname = "http-types";
  version = "0.7.3.0.1";
  sha256 = "1s2dh75jpf2yllw503hjw0x2anhc4c71vz5yylri8nxzx1zs18rq";
  buildDepends = [ blazeBuilder caseInsensitive text ];
  meta = {
    homepage = "https://github.com/aristidb/http-types";
    description = "Generic HTTP types for Haskell (for both client and server code)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
