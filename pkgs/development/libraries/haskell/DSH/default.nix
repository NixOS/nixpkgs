{ cabal, convertible, csv, FerryCore, HaXml, HDBC, json, mtl
, Pathfinder, syb, text, xhtml
}:

cabal.mkDerivation (self: {
  pname = "DSH";
  version = "0.7.8.1";
  sha256 = "1yz8rh3hkqc465slfzi7jqhjd1xrmcghjxl7zprxw082p2qvj8g5";
  buildDepends = [
    convertible csv FerryCore HaXml HDBC json mtl Pathfinder syb text
    xhtml
  ];
  meta = {
    description = "Database Supported Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
