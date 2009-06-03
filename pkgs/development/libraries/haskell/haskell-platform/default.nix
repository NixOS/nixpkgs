{cabal, fetchurl, GLUT, HTTP, HUnit, OpenGL, QuickCheck, cgi, fgl, editline,
 haskellSrc, html, parallel, regexBase, regexCompat, regexPosix,
 stm, time, xhtml, zlib, cabalInstall, alex, happy, haddock, ghc}:

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2009.2.0.1";
  src = fetchurl {
    url = "http://hackage.haskell.org/platform/${self.version}/cabal/${self.pname}-${self.version}.tar.gz";
    sha256 = "33a828ed6cd1e6cc32cfec3fd55e6ab4d8026bd7451bab65ec0873880c0f11c5";
  };
  propagatedBuildInputs = [
    GLUT HTTP HUnit OpenGL QuickCheck cgi fgl editline
    haskellSrc html parallel regexBase regexCompat regexPosix
    stm time xhtml zlib cabalInstall alex happy ghc
  ];
  meta = {
    description = "Haskell Platform meta package";
  };
})  

