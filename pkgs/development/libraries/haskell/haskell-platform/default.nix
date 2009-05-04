{cabal, fetchurl, GLUT, HTTP, HUnit, OpenGL, QuickCheck, cgi, fgl,
 haskellSrc, html, parallel, regexBase, regexCompat, regexPosix,
 stm, time, xhtml, zlib, cabalInstall, alex, happy, haddock, ghc}:

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2009.1.1";
  src = fetchurl {
    url = http://code.haskell.org/haskell-platform/haskell-platform.cabal;
    sha256 = "755f8fd3c0fa399a27b1520f5366e4dbe5b505a3a229deac9d2cdfa4cc595137";
  };
  unpackPhase = ''
    cp $src haskell-platform.cabal
  '';
  preConfigure = ''
    sed -i 's/^.*cabal-install ==.*$//' haskell-platform.cabal
    echo 'import Distribution.Simple; main = defaultMain' > Setup.hs
    touch LICENSE
  '';
  propagatedBuildInputs = [
    GLUT HTTP HUnit OpenGL QuickCheck cgi fgl
    haskellSrc html parallel regexBase regexCompat regexPosix
    stm time xhtml zlib cabalInstall alex happy ghc
  ];
  meta = {
    description = "Haskell Platform meta package";
  };
})  

