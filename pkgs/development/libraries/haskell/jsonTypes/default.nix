{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "json-types";
  version = "0.1";
  sha256 = "088if9qv0didjyb6y1583viihjgc4nwr61qfjqdg9rzc2ya6vqdn";
  buildDepends = [ text ];
  meta = {
    description = "Basic types for representing JSON";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
