{cabal, fetchurl, GLUT, HTTP, HUnit, OpenGL, QuickCheck, cgi, fgl,
 haskellSrc, html, parallel, regexBase, regexCompat, regexPosix,
 stm, time, xhtml, zlib, cabalInstall, alex, happy, haddock, ghc}:

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2009.2.0";
  src = fetchurl {
    url = http://code.haskell.org/haskell-platform/haskell-platform.cabal;
    sha256 = "04b50748554ed3b6ed41997798c0ef4f5423bd2c84ea966d8e27cff3c5d0e581";
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

