{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, bytestringMmap, caseInsensitive, deepseq
, enumerator, filepath, HUnit, MonadCatchIOTransformers, mtl
, random, regexPosix, text, time, unixCompat, unorderedContainers
, vector, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.9.3.1";
  sha256 = "1q2lk70l0hk4l6ksjnal1bfkby0i08gdzvj9cscvxs4njxmgdapq";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder blazeBuilderEnumerator
    bytestringMmap caseInsensitive deepseq enumerator filepath HUnit
    MonadCatchIOTransformers mtl random regexPosix text time unixCompat
    unorderedContainers vector zlibEnum
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework (core interfaces and types)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
