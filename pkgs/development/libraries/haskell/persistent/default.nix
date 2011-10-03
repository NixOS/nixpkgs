{ cabal, blazeHtml, dataObject, enumerator, monadControl, mtl
, pathPieces, pool, sqlite, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.6.3";
  sha256 = "0m50z9k941bhh05jjz1268sn1bi7w8i6jzccldgnbjjvsw2xaisx";
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
