{ cabal, alex, binary, filepath, happy, hashable, hashtables
, haskeline, haskellSrcExts, mtl, QuickCheck, syb, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "Agda";
  version = "2.3.0.1";
  sha256 = "0f2kc3by2z01g8bqc446hyzx9sidx6qi0p7h5bcpjf8iryk1dh2w";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary filepath hashable hashtables haskeline haskellSrcExts mtl
    QuickCheck syb xhtml zlib
  ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://wiki.portal.chalmers.se/agda/";
    description = "A dependently typed functional programming language and proof assistant";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
