{ cabal, dataDefaultClass, lens, vectorSpace, vectorSpacePoints }:

cabal.mkDerivation (self: {
  pname = "force-layout";
  version = "0.3";
  sha256 = "1v4jgh08ppvfxc8w13wc9iiwk5hh2q9n7m5xb9vl59bmxdx81kai";
  buildDepends = [
    dataDefaultClass lens vectorSpace vectorSpacePoints
  ];
  meta = {
    description = "Simple force-directed layout";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
