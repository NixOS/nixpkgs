{ cabal, conduit, dataDefault, digest, HUnit, lens, smallcheck
, tasty, tastyHunit, tastySmallcheck, text, time, transformers
, utf8String, xmlConduit, xmlTypes, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "xlsx";
  version = "0.1.0.2";
  sha256 = "0m9ph34mpnc6vj1d3x80y0gaya5bqdhfa193jn0a8clw4qz88sbr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    conduit dataDefault digest lens text time transformers utf8String
    xmlConduit xmlTypes zipArchive zlib
  ];
  testDepends = [
    HUnit smallcheck tasty tastyHunit tastySmallcheck time
  ];
  meta = {
    homepage = "https://github.com/qrilka/xlsx";
    description = "Simple and incomplete Excel file parser/writer";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
