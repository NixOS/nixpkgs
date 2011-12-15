{ cabal, blazeHtml, dataObject, enumerator, monadControl, mtl
, pathPieces, pool, sqlite, text, time, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.6.4.3";
  sha256 = "0j4agwm8hcphrmzmc7d7al57cwp3i5iy7d8yhqw9m8pcx61sqkg4";
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
