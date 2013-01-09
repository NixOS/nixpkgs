{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "mime-types";
  version = "0.1.0.1";
  sha256 = "1a34ckmv8qcyk38jydxwph59zcrhnwaah1h6pzn112kysjqjgcsl";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Basic mime-type handling types and functions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
