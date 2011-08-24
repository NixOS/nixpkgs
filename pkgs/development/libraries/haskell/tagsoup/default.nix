{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "tagsoup";
  version = "0.12.3";
  sha256 = "0f41kc6kdzslyhskyql431nq0kkdzf13vn9saqi48ycajnrm1vcb";
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
