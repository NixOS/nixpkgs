{ cabal, exceptions, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-safe";
  version = "2.0.1";
  sha256 = "11516rixqdym5rf5z5f5gwbfk689dl3ka3dj44c7a2qy7xl4sqzr";
  buildDepends = [ exceptions pipes transformers ];
  meta = {
    description = "Safety for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
