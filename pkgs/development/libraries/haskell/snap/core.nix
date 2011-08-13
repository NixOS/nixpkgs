{ cabal, MonadCatchIOTransformers, attoparsec, attoparsecEnumerator
, blazeBuilder, bytestringMmap, bytestringNums, caseInsensitive
, deepseq, dlist, enumerator, mtl, text, time, transformers
, unixCompat, vector, zlib
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.5.3";
  sha256 = "0326l4wiv5pn8yc1xz1pr5738aglm5lpni6wxni7dkjwb53744dm";
  buildDepends = [
    MonadCatchIOTransformers attoparsec attoparsecEnumerator
    blazeBuilder bytestringMmap bytestringNums caseInsensitive deepseq
    dlist enumerator mtl text time transformers unixCompat vector zlib
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
