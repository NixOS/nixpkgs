{ cabal, blazeHtml, enumerator, monadControl, mtl, pathPieces, pool
, sqlite, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.6.2";
  sha256 = "1bzv3wqqy32z20xbda8kr4m1fybnziv0gp6m8v3w0brrvmns20g2";
  buildDepends = [
    blazeHtml enumerator monadControl mtl pathPieces pool text time
    transformers
  ];
  extraLibraries = [ sqlite ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
