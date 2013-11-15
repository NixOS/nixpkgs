{ cabal, boomerang, mtl, parsec, text, webRoutes }:

cabal.mkDerivation (self: {
  pname = "web-routes-boomerang";
  version = "0.28.0";
  sha256 = "1xp8p0fkwirrpssb9lnxl7fmlmrql28r2ywaa99gw9cdqxifzbbl";
  buildDepends = [ boomerang mtl parsec text webRoutes ];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
