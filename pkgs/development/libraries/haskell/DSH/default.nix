{ cabal, csv, FerryCore, HaXml, HDBC, mtl, Pathfinder, text }:

cabal.mkDerivation (self: {
  pname = "DSH";
  version = "0.8.2.2";
  sha256 = "0hjy8c97avi4wwv3p9gyml66n34mbrfrhb19j5y6vcy0y8ysgf0c";
  buildDepends = [ csv FerryCore HaXml HDBC mtl Pathfinder text ];
  meta = {
    description = "Database Supported Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
