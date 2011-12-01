{ cabal, blazeHtml, dataObject, enumerator, monadControl, mtl
, pathPieces, pool, sqlite, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.6.4.1";
  sha256 = "06l04yb49iiw4lyyy1vk138v3g2jh8xwd4bzpcagkh62jrvq559a";
  buildDepends = [
    blazeHtml dataObject enumerator monadControl mtl pathPieces pool
    text time transformers
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
