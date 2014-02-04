{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "boomerang";
  version = "1.4.2";
  sha256 = "0vy70anwnh7649za6nzb65fx09vqkf50a961da6gzwvbaf526rd0";
  buildDepends = [ mtl text ];
  meta = {
    description = "Library for invertible parsing and printing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
