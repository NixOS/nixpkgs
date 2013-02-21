{ cabal, alex, binary, deepseq, filepath, geniplate, happy
, hashable, hashtables, haskeline, haskellSrcExts, mtl, parallel
, QuickCheck, text, unorderedContainers, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "Agda";
  version = "2.3.2";
  sha256 = "1xp0qvag6wx6zjwhmb7nm13hp63vlh8h4a2rkc85rsh610m0nynl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary deepseq filepath geniplate hashable hashtables haskeline
    haskellSrcExts mtl parallel QuickCheck text unorderedContainers
    xhtml zlib
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
