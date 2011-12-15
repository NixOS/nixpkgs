{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "tagsoup";
  version = "0.12.6";
  sha256 = "1q1dzsaj131fcvibka72i7si1i0gxkz5d9zl0akd8mbapy5mmlv5";
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
