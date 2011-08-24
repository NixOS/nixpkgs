{ cabal, alex, binary, happy, haskeline, haskellSrcExts, mtl
, QuickCheck, syb, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "Agda";
  version = "2.2.10";
  sha256 = "1bh96g5c6b6jzaf3m9gm0vr64avgi86kb45p8i1vg1jbfjdbdlsw";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary haskeline haskellSrcExts mtl QuickCheck syb xhtml zlib
  ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://wiki.portal.chalmers.se/agda/";
    description = "A dependently typed functional programming language and proof assistant";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
