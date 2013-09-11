{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, bytestringMmap, caseInsensitive, deepseq
, enumerator, filepath, hashable, HUnit, MonadCatchIOTransformers
, mtl, random, regexPosix, text, time, unixCompat
, unorderedContainers, vector, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.9.4.1";
  sha256 = "0yacbpd20y49jw1qkrm5r4qick0fhimgb07883bg1lp3ai4ysrk5";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder blazeBuilderEnumerator
    bytestringMmap caseInsensitive deepseq enumerator filepath hashable
    HUnit MonadCatchIOTransformers mtl random regexPosix text time
    unixCompat unorderedContainers vector zlibEnum
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework (core interfaces and types)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
