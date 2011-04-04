{cabal, fetchurl, GLUT, HTTP, HUnit, OpenGL, QuickCheck, cgi, fgl,
 haskellSrc, html, network, parallel, parsec, regexBase, regexCompat, regexPosix,
 stm, syb, deepseq, text, transformers, mtl, xhtml, zlib,
 cabalInstall, alex, happy, haddock, ghc}:

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2011.2.0.1";
  src = fetchurl {
    url = "http://lambda.haskell.org/hp-tmp/2011.2.0.0/cabal/${self.pname}-2011.2.0.0.tar.gz";
    sha256 = "01ppv8jdyvbngml9vgvrvnani6fj1nbk8mqmrkd8c508l7q9g6vb";
  };
  cabalFile = fetchurl {
    url = http://code.galois.com/darcs/haskell-platform/haskell-platform.cabal;
    sha256 = "158a1g4ak9mm2q5ri4zdpmbvjgfkz7svxnkxlz8117zpnbs12i3d";
  };
  propagatedBuildInputs = [
    GLUT HTTP HUnit OpenGL QuickCheck cgi fgl
    haskellSrc html network parallel parsec regexBase regexCompat regexPosix
    stm syb deepseq text transformers mtl xhtml zlib
    cabalInstall alex happy ghc haddock
  ];
  preConfigure = ''
    cp ${self.cabalFile} ${self.pname}.cabal
  '';
  noHaddock = true;
  meta = {
    description = "Haskell Platform meta package";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

