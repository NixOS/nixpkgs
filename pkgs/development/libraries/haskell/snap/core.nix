{ cabal, attoparsec, attoparsecEnumerator, base16Bytestring
, blazeBuilder, blazeBuilderEnumerator, bytestringMmap
, bytestringNums, caseInsensitive, deepseq, dlist, enumerator
, HUnit, MonadCatchIOTransformers, mtl, mwcRandom, regexPosix, text
, time, transformers, unixCompat, unorderedContainers, vector
, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.6.0";
  sha256 = "1rf85chybjsfva502bmjgfvhv4b6clrjg6i9ywcr3gwnk4ngw165";
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
