{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, bytestringMmap, bytestringNums, caseInsensitive, deepseq, dlist
, enumerator, MonadCatchIOTransformers, mtl, text, time
, transformers, unixCompat, vector, zlib
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.5.4";
  sha256 = "0v6lsb60s3w96rqpp9ky8nd660zja8asw02vx1562nvd19k65jbb";
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
