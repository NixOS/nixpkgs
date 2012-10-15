{ cabal, csv, FerryCore, HaXml, HDBC, mtl, Pathfinder, text }:

cabal.mkDerivation (self: {
  pname = "DSH";
  version = "0.8.1.0";
  sha256 = "13mkpcm34jg7hqc272phiak7rg590hxb6ma3s9lwvp6izcv7vccq";
  buildDepends = [ csv FerryCore HaXml HDBC mtl Pathfinder text ];
  meta = {
    description = "Database Supported Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
