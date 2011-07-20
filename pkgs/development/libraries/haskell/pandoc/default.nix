{cabal, HTTP, citeprocHs, dlist, tagsoup, texmath, xhtml, zipArchive}:

cabal.mkDerivation (self : {
  pname = "pandoc";
  version = "1.8.1.2";
  sha256 = "93b23b7ff91ac6d91c8b3945175967fa4da5a5587c1147a19a1a20c8d61b734d";
  propagatedBuildInputs =
    [HTTP citeprocHs dlist tagsoup texmath xhtml zipArchive];
  meta = {
    description = "Conversion between markup formats";
  };
})
