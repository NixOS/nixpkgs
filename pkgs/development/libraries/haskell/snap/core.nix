{ cabal, attoparsec, attoparsecEnumerator, base16Bytestring
, blazeBuilder, blazeBuilderEnumerator, bytestringMmap
, bytestringNums, caseInsensitive, deepseq, dlist, enumerator
, HUnit, MonadCatchIOTransformers, mtl, mwcRandom, regexPosix, text
, time, transformers, unixCompat, unorderedContainers, vector
, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.7.0.1";
  sha256 = "010w3ycwalz48288342rmwg87pdml7ixg9drw38k206q9s9a9cp9";
  buildDepends = [
    attoparsec attoparsecEnumerator base16Bytestring blazeBuilder
    blazeBuilderEnumerator bytestringMmap bytestringNums
    caseInsensitive deepseq dlist enumerator HUnit
    MonadCatchIOTransformers mtl mwcRandom regexPosix text time
    transformers unixCompat unorderedContainers vector zlibEnum
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
