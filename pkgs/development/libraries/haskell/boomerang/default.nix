{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "boomerang";
  version = "1.4.1";
  sha256 = "0pmaysp6vw6cnxh3px47pwflm4fc83idld09bpnfnh2jkscp630a";
  buildDepends = [ mtl text ];
  meta = {
    description = "Library for invertible parsing and printing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
