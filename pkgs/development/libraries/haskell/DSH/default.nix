{ cabal, csv, FerryCore, HaXml, HDBC, mtl, Pathfinder, text }:

cabal.mkDerivation (self: {
  pname = "DSH";
  version = "0.8.0.1";
  sha256 = "08bwn7jpnkzvyj2dlpk6zx97iwsjb085vbnc8hwvxnhf9y8wl96s";
  buildDepends = [ csv FerryCore HaXml HDBC mtl Pathfinder text ];
  meta = {
    description = "Database Supported Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
