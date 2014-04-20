{ cabal, boomerang, mtl, parsec, text, webRoutes }:

cabal.mkDerivation (self: {
  pname = "web-routes-boomerang";
  version = "0.28.2";
  sha256 = "17237xq8nvy0c1mxzf7pad5kw0mrgbzazy0rflp382ig9q6ipd05";
  buildDepends = [ boomerang mtl parsec text webRoutes ];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
