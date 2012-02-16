{ cabal, convertible, csv, FerryCore, HaXml, HDBC, json, mtl
, Pathfinder, syb, text, xhtml
}:

cabal.mkDerivation (self: {
  pname = "DSH";
  version = "0.7.8";
  sha256 = "1mlym2hs7sr78lih8c0yi5y5h14vxy3zpl3gfnidh9wiw5cai9lg";
  buildDepends = [
    convertible csv FerryCore HaXml HDBC json mtl Pathfinder syb text
    xhtml
  ];
  meta = {
    description = "Database Supported Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
