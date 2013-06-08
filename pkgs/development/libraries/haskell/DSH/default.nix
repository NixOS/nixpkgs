{ cabal, csv, FerryCore, HaXml, HDBC, mtl, Pathfinder, text }:

cabal.mkDerivation (self: {
  pname = "DSH";
  version = "0.8.2.3";
  sha256 = "0d5jh1vxjx3874rgwvxjm00lj3vvp8ggz2c54x6ymhmgav3pd8vy";
  buildDepends = [ csv FerryCore HaXml HDBC mtl Pathfinder text ];
  meta = {
    description = "Database Supported Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
