{ cabal, blazeHtml, enumerator, monadControl, mtl, parsec
, pathPieces, pool, sqlite, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.6.1";
  sha256 = "1pb34n7rwj6jvk18c802kd99rrlhrav1hkx600rs6pp5zjic3mp7";
  buildDepends = [
    blazeHtml enumerator monadControl mtl parsec pathPieces pool text
    time transformers
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
