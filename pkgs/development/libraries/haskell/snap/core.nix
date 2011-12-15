{ cabal, attoparsec, attoparsecEnumerator, base16Bytestring
, blazeBuilder, blazeBuilderEnumerator, bytestringMmap
, bytestringNums, caseInsensitive, deepseq, dlist, enumerator
, HUnit, MonadCatchIOTransformers, mtl, mwcRandom, regexPosix, text
, time, transformers, unixCompat, unorderedContainers, vector
, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.7";
  sha256 = "1rplv1pg531jfmvxlhl7lz9hdhbxllk59daik013i172wglggivp";
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
