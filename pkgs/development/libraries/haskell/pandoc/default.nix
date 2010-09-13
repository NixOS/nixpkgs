{cabal, mtl, network, parsec, utf8String, xhtml, zipArchive, HTTP, xml,
 texmath, random ? null}:

cabal.mkDerivation (self : {
  pname = "pandoc";
  version = "1.6";
  sha256 = "9b825233293edf1ea414b0e7ea821d6a914711dc2c60546566ab5a97512b079b";
  propagatedBuildInputs = [
    mtl network parsec utf8String xhtml zipArchive HTTP xml texmath
  ] ++ (if random != null then [random] else []);
  meta = {
    description = "Conversion between markup formats";
  };
})
