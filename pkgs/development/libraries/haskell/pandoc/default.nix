{cabal, HTTP, citeprocHs, dlist, tagsoup, texmath, xhtml, zipArchive}:

cabal.mkDerivation (self : {
  pname = "pandoc";
  version = "1.8.1.1";
  sha256 = "0g680j8x3v19wcb9k2dxgrdrjr48w0vhvlspfzgw0sgzrgfmaqsj";
  propagatedBuildInputs =
    [HTTP citeprocHs dlist tagsoup texmath xhtml zipArchive];
  meta = {
    description = "Conversion between markup formats";
  };
})
