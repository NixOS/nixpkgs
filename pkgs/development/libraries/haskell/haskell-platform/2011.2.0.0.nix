{cabal, fetchurl, GLUT, HTTP, HUnit, OpenGL, QuickCheck, cgi, fgl,
 haskellSrc, html, network, parallel, parsec, regexBase, regexCompat, regexPosix,
 stm, syb, deepseq, text, transformers, mtl, xhtml, zlib,
 cabalInstall, alex, happy, haddock, ghc}:

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2011.2.0.0";
  src = fetchurl {
    # url = "http://hackage.haskell.org/platform/${self.version}/cabal/${self.pname}-${self.version}.tar.gz";
    url = "http://lambda.haskell.org/hp-tmp/${self.version}/cabal/${self.pname}-${self.version}.tar.gz";
    sha256 = "01ppv8jdyvbngml9vgvrvnani6fj1nbk8mqmrkd8c508l7q9g6vb";
  };
  propagatedBuildInputs = [
    GLUT HTTP HUnit OpenGL QuickCheck cgi fgl
    haskellSrc html network parallel parsec regexBase regexCompat regexPosix
    stm syb deepseq text transformers mtl xhtml zlib
    cabalInstall alex happy ghc haddock
  ];
  noHaddock = true;
  meta = {
    description = "Haskell Platform meta package";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

