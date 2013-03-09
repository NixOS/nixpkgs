{ cabal, logict, mtl }:

cabal.mkDerivation (self: {
  pname = "smallcheck";
  version = "1.0.1";
  sha256 = "1b8g7vgvwyz2smx16gbn73k749mazj2zmr2hjhqj4rk0433i6lpk";
  buildDepends = [ logict mtl ];
  meta = {
    homepage = "https://github.com/feuerbach/smallcheck";
    description = "A property-based testing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
