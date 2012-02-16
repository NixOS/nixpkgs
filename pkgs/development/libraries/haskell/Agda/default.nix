{ cabal, alex, binary, filepath, happy, hashable, hashtables
, haskeline, haskellSrcExts, mtl, QuickCheck, syb, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "Agda";
  version = "2.3.0";
  sha256 = "1p0cwf3d146z73gp49cm8fmk33hcbjsvyijbakm1871ssc5i73k0";
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
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
