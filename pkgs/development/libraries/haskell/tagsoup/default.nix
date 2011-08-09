{cabal, text} :

cabal.mkDerivation (self : {
  pname = "tagsoup";
  version = "0.12.2";
  sha256 = "066nmp4fd5pcx9xiq7lhxcrhmnhkxk8z7zx5laa19bbb8jbjjl4y";
  propagatedBuildInputs = [ text ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/tagsoup/";
    description = "Parsing and extracting information from (possibly malformed) HTML/XML documents";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
