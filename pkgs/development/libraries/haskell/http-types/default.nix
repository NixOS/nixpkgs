{ cabal, blazeBuilder, caseInsensitive, text }:

cabal.mkDerivation (self: {
  pname = "http-types";
  version = "0.7.1";
  sha256 = "1vfaffraiqdsjbw4b0xwk8h8d4pl94mbxlwyqk8ry786v9aafyqx";
  buildDepends = [ blazeBuilder caseInsensitive text ];
  meta = {
    homepage = "https://github.com/aristidb/http-types";
    description = "Generic HTTP types for Haskell (for both client and server code)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
