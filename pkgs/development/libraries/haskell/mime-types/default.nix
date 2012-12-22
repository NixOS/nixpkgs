{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "mime-types";
  version = "0.1.0.0";
  sha256 = "0xc36pr84nszyych3jd8sl6kj1grsyv8ci8v7ilrbpnw7ngbkw1p";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Basic mime-type handling types and functions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
