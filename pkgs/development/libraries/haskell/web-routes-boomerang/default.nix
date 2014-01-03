{ cabal, boomerang, mtl, parsec, text, webRoutes }:

cabal.mkDerivation (self: {
  pname = "web-routes-boomerang";
  version = "0.28.1";
  sha256 = "1a655d73fr7b9k033wyqgc8waq7ii3s5rh0w3nkb1phxl9ldg0pi";
  buildDepends = [ boomerang mtl parsec text webRoutes ];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
