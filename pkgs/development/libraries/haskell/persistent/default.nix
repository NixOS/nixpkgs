{ cabal, blazeHtml, dataObject, enumerator, monadControl, mtl
, pathPieces, pool, sqlite, text, time, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.6.4.4";
  sha256 = "0n4zl0r8nmp3pwsgc0kiy7fgk2dfvdvagv1gvjxrs8545c5ycggv";
  buildDepends = [
    blazeHtml dataObject enumerator monadControl mtl pathPieces pool
    text time transformers transformersBase
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
