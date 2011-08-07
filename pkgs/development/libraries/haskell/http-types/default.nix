{cabal, blazeBuilder, caseInsensitive, text} :

cabal.mkDerivation (self : {
  pname = "http-types";
  version = "0.6.5.1";
  sha256 = "1gmf5ghfm8hzifinknyk10m7ayxkn48h1l0mchi2vl6h5rg0nnca";
  propagatedBuildInputs = [ blazeBuilder caseInsensitive text ];
  meta = {
    homepage = "https://github.com/aristidb/http-types";
    description = "Generic HTTP types for Haskell (for both client and server code).";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
