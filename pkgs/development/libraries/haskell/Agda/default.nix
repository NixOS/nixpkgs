{ cabal, alex, binary, deepseq, filepath, geniplate, happy
, hashable, hashtables, haskeline, haskellSrcExts, mtl, parallel
, QuickCheck, text, time, unorderedContainers, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "Agda";
  version = "2.3.2.1";
  sha256 = "1dlf0cs913ma8wjvra8x6p0lwi1pk7ynbdq4lxgbdfgqkbnh43kr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary deepseq filepath geniplate hashable hashtables haskeline
    haskellSrcExts mtl parallel QuickCheck text time
    unorderedContainers xhtml zlib
  ];
  buildTools = [ alex happy ];
  jailbreak = true;
  meta = {
    homepage = "http://wiki.portal.chalmers.se/agda/";
    description = "A dependently typed functional programming language and proof assistant";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
