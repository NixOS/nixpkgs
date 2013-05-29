{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "boomerang";
  version = "1.3.3";
  sha256 = "1i44j3qyjkq69h65wfsrps5zp097i3nh9fwcb2f1spr8nznb5mff";
  buildDepends = [ mtl text ];
  meta = {
    description = "Library for invertible parsing and printing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
