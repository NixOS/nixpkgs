{cabal, fetchurl, GLUT, HTTP, HUnit, OpenAL, OpenGL, QuickCheck, cgi, fgl,
 haskellSrc, html, parallel, regexBase, regexCompat, regexPosix,
 stm, time, xhtml, zlib, cabalInstall, alex, happy, haddock}:

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2009.0.0";
  src = fetchurl {
    url = http://code.haskell.org/haskell-platform/haskell-platform.cabal;
    sha256 = "cefe19076bed6450d3d8611ff1b29fd0966106787003abedec90544968f30d9c";
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
    GLUT HTTP HUnit OpenAL OpenGL QuickCheck cgi fgl
    haskellSrc html parallel regexBase regexCompat regexPosix
    stm time xhtml zlib cabalInstall alex happy
  ];
  /*
  postFixup = ''
    ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
  '';
  */
  meta = {
    description = "Haskell Platform meta package";
  };
})  

