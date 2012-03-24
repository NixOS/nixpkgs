{ cabal, attoparsec, attoparsecEnumerator, base16Bytestring
, blazeBuilder, blazeBuilderEnumerator, bytestringMmap
, bytestringNums, caseInsensitive, deepseq, dlist, enumerator
, filepath, HUnit, MonadCatchIOTransformers, mtl, mwcRandom
, regexPosix, text, time, transformers, unixCompat
, unorderedContainers, vector, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.8.0.1";
  sha256 = "0lw1c5gczb75878vr5acjck656aq5zg1hva9bfny321v0442azds";
  buildDepends = [
    attoparsec attoparsecEnumerator base16Bytestring blazeBuilder
    blazeBuilderEnumerator bytestringMmap bytestringNums
    caseInsensitive deepseq dlist enumerator filepath HUnit
    MonadCatchIOTransformers mtl mwcRandom regexPosix text time
    transformers unixCompat unorderedContainers vector zlibEnum
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework (core interfaces and types)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
