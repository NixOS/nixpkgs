{cabal, fetchurl, GLUT, HTTP, HUnit, OpenGL, QuickCheck, cgi, fgl,
 haskellSrc, html, network, parallel, regexBase, regexCompat, regexPosix,
 stm, xhtml, zlib, parsec,
 cabalInstall, alex, happy, ghc}:

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2010.1.0.0";
  src = fetchurl {
    url = "http://hackage.haskell.org/platform/${self.version}/cabal/${self.pname}-${self.version}.tar.gz";
    sha256 = "0cadj0ql2i5d5njwcbhmjkf4qrkfmxirg5vjv1wlx3ayzbynbrp4";
  };
  isLibrary = false;
  propagatedBuildInputs = [
    GLUT HTTP HUnit OpenGL QuickCheck cgi fgl
    haskellSrc html network parallel regexBase regexCompat regexPosix
    stm xhtml zlib parsec
    cabalInstall alex happy ghc
  ];
  meta = {
    description = "Haskell Platform meta package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [andres simons];
  };
})
