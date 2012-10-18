{ cabal, csv, FerryCore, HaXml, HDBC, mtl, Pathfinder, text }:

cabal.mkDerivation (self: {
  pname = "DSH";
  version = "0.8.2.1";
  sha256 = "0rm5r5fmf1qxn4q5d6l8aid5d7i9i4hzdgimwpcw6d3mzg0sbl1c";
  buildDepends = [ csv FerryCore HaXml HDBC mtl Pathfinder text ];
  meta = {
    description = "Database Supported Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
