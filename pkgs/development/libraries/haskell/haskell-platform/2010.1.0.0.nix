{cabal, fetchurl, GLUT, HTTP, HUnit, OpenGL, QuickCheck, cgi, fgl,
 haskellSrc, html, network, parallel, regexBase, regexCompat, regexPosix,
 stm, xhtml, zlib, cabalInstall, alex, happy, haddock, ghc}:

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2010.1.0.0";
  src = fetchurl {
    url = "http://hackage.haskell.org/platform/${self.version}/cabal/${self.pname}-${self.version}.tar.gz";
    sha256 = "64c9fec5cdc4b6f515b7f296d59984d2dee05927b7e24ea67324ad5f4ac3e994";
  };
  propagatedBuildInputs = [
    GLUT HTTP HUnit OpenGL QuickCheck cgi fgl
    haskellSrc html network parallel regexBase regexCompat regexPosix
    stm xhtml zlib cabalInstall alex happy ghc haddock
  ];
  meta = {
    description = "Haskell Platform meta package";
  };
})  

