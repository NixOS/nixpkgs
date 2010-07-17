{cabal, fetchurl, GLUT, HTTP, HUnit, OpenGL, QuickCheck, cgi, fgl,
 haskellSrc, html, network, parallel, regexBase, regexCompat, regexPosix,
 stm, xhtml, zlib, cabalInstall, alex, happy, haddock, ghc}:

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2010.2.0.0";
  src = fetchurl {
    url = "http://hackage.haskell.org/platform/${self.version}/cabal/${self.pname}-${self.version}.tar.gz";
    sha256 = "b0f4e6827d653f68865f39679c7c4fd5c22030ef5d7d24df3270aa6db4b016d4";
  };
  propagatedBuildInputs = [
    GLUT HTTP HUnit OpenGL QuickCheck cgi fgl
    haskellSrc html network parallel regexBase regexCompat regexPosix
    stm xhtml zlib cabalInstall alex happy ghc haddock
  ];
  meta = {
    description = "Haskell Platform meta package";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

