{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "tagsoup";
  version = "0.12.4";
  sha256 = "0szm80sgjj173vdax7gv87mfp9xrq1w34i4v83nbvnfwrx8nis4w";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ text ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/tagsoup/";
    description = "Parsing and extracting information from (possibly malformed) HTML/XML documents";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
