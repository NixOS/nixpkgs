{ cabal, convertible, csv, FerryCore, HaXml, HDBC, json, mtl
, Pathfinder, syb, text, xhtml
}:

cabal.mkDerivation (self: {
  pname = "DSH";
  version = "0.7.8.2";
  sha256 = "1rs42c05q4s46a1a03srzdq0aijwalhilzifc8ryq4qwjgh7vkwz";
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
