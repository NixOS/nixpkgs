{cabal, mtl, network, parsec, utf8String, xhtml, zipArchive, HTTP, xml,
 texmath}:

cabal.mkDerivation (self : {
  pname = "pandoc";
  version = "1.5.1.1";
  sha256 = "6d2283cb618fcaea5ee5cb885ef6532bc34628b351f14a6bd85b098d7a4128d9";
  propagatedBuildInputs = [
    mtl network parsec utf8String xhtml zipArchive HTTP xml texmath
  ];
  meta = {
    description = "Conversion between markup formats";
  };
})  

