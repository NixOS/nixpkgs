{cabal, fetchurl, GLUT, HTTP, HUnit, OpenGL, QuickCheck, cgi, fgl,
 haskellSrc, html, network, parallel, parsec, regexBase, regexCompat, regexPosix,
 stm, syb, deepseq, text, transformers, mtl, xhtml, zlib,
 cabalInstall, alex, happy, haddock, ghc}:

# This is just a meta-package. Because upstream fails to provide proper versioned
# release tarballs that can be used for the purpose of verifying this package, we
# just create it on the fly from a simple Setup.hs file and a .cabal file that we
# store directly in the nixpkgs repository.

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2011.4.0.0";
  cabalFile = ./haskell-platform-2011.4.0.0.cabal;
  setupFile = ./Setup.hs;
  src = null;
  propagatedBuildInputs = [
    GLUT HTTP HUnit OpenGL QuickCheck cgi fgl
    haskellSrc html network parallel parsec regexBase regexCompat regexPosix
    stm syb deepseq text transformers mtl xhtml zlib
    cabalInstall alex happy ghc haddock
  ];
  unpackPhase = ''
    sourceRoot=haskell-platform
    mkdir $sourceRoot
    cp ${self.cabalFile} $sourceRoot/${self.pname}.cabal
    cp ${self.setupFile} $sourceRoot/Setup.hs
    touch $sourceRoot/LICENSE
  '';
  noHaddock = true;
  meta = {
    homepage = "http://haskell.org/platform";
    description = "Haskell Platform meta package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})

