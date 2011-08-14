{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, bytestringMmap, bytestringNums, caseInsensitive, deepseq, dlist
, enumerator, MonadCatchIOTransformers, mtl, text, time
, transformers, unixCompat, vector, zlib
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.5.3.1";
  sha256 = "0qwlcak1hi4cqyhnks7qqf4zq0rw2486paf0mlasyzb6ba0pwl6m";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder bytestringMmap
    bytestringNums caseInsensitive deepseq dlist enumerator
    MonadCatchIOTransformers mtl text time transformers unixCompat
    vector zlib
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework (Core)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
