{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, bytestringMmap, bytestringNums
, caseInsensitive, deepseq, dlist, enumerator
, MonadCatchIOTransformers, mtl, text, time, transformers
, unixCompat, vector, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.5.5";
  sha256 = "1md9n3f11ki87774fh3p7d6bykfdwcqz6b2yrjci4mwf1b1xppkj";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder blazeBuilderEnumerator
    bytestringMmap bytestringNums caseInsensitive deepseq dlist
    enumerator MonadCatchIOTransformers mtl text time transformers
    unixCompat vector zlibEnum
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
