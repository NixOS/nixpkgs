{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, bytestringMmap, caseInsensitive, deepseq
, enumerator, filepath, HUnit, MonadCatchIOTransformers, mtl
, random, regexPosix, text, time, unixCompat, unorderedContainers
, vector, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.9.2.2";
  sha256 = "0svahih2piaj87xfysgjvqqh11gmwz9icrh2g819h68kzh10imlf";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder blazeBuilderEnumerator
    bytestringMmap caseInsensitive deepseq enumerator filepath HUnit
    MonadCatchIOTransformers mtl random regexPosix text time unixCompat
    unorderedContainers vector zlibEnum
  ];
  jailbreak = true;
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework (core interfaces and types)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
