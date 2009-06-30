{cabal, mtl, network, parsec, utf8String, xhtml, zipArchive}:

cabal.mkDerivation (self : {
  pname = "pandoc";
  version = "1.2";
  sha256 = "e922c8f4765a8d105abf30dbe21a73961357929cd2fb8dfd323f0f62ca0723b4";
  propagatedBuildInputs = [mtl network parsec utf8String xhtml zipArchive];
  meta = {
    description = "Conversion between markup formats";
  };
})  

