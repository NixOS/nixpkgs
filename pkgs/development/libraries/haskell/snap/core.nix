{ cabal, attoparsec, attoparsecEnumerator, base16Bytestring
, blazeBuilder, blazeBuilderEnumerator, bytestringMmap
, bytestringNums, caseInsensitive, deepseq, dlist, enumerator
, HUnit, MonadCatchIOTransformers, mtl, mwcRandom, regexPosix, text
, time, transformers, unixCompat, unorderedContainers, vector
, zlibEnum
}:

cabal.mkDerivation (self: {
  pname = "snap-core";
  version = "0.6.0.1";
  sha256 = "1vcpi56a5cia8z7n3zskhl2b7v9vkqkr87hy8n3hz5lz1lc82kkz";
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
