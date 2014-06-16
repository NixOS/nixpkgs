{cabal, fetchurl, GLUT, HTTP, HUnit, OpenGL, QuickCheck, cgi, fgl, editline,
 haskellSrc, html, parallel, regexBase, regexCompat, regexPosix,
 stm, time, xhtml, zlib, parsec, network,
 cabalInstall, alex, happy, ghc}:

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2009.2.0.2";
  src = fetchurl {
    url = "http://hackage.haskell.org/platform/${self.version}/cabal/${self.pname}-${self.version}.tar.gz";
    sha256 = "e0469fac9b1d091d8299ae16a4e2e7fcd504285bba066b17153a0f0104a049bd";
  };
  isLibrary = false;
  propagatedBuildInputs = [
    GLUT HTTP HUnit OpenGL QuickCheck cgi fgl editline
    haskellSrc html parallel regexBase regexCompat regexPosix
    stm time xhtml zlib parsec network
    cabalInstall alex happy ghc
  ];
  meta = {
    description = "Haskell Platform meta package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [andres simons];
  };
})
