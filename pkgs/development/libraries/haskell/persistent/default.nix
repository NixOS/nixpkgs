{ cabal, blazeHtml, dataObject, enumerator, monadControl, mtl
, pathPieces, pool, sqlite, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.6.4";
  sha256 = "149dk6i6w36rq3z6zzrcmpr0kxpp6hk0qpc43vwj0dm68nrffaqk";
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
