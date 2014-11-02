{ cabal, fetchurl
, async, attoparsec, caseInsensitive, cgi, fgl, GLUT, GLURaw, haskellSrc
, hashable, html, HTTP, HUnit, mtl, network, OpenGL, OpenGLRaw, parallel
, parsec, QuickCheck, random, regexBase, regexCompat, regexPosix, split, stm
, syb, text, transformers, unorderedContainers, vector, xhtml, zlib
, cabalInstall, alex, happy, primitive, ghc
}:

# This is just a meta-package. Because upstream fails to provide proper versioned
# release tarballs that can be used for the purpose of verifying this package, we
# just create it on the fly from a simple Setup.hs file and a .cabal file that we
# store directly in the nixpkgs repository.

cabal.mkDerivation (self : {
  pname = "haskell-platform";
  version = "2013.2.0.0";
  cabalFile = ./haskell-platform-2013.2.0.0.cabal;
  setupFile = ./Setup.hs;
  src = null;
  isLibrary = false;
  propagatedBuildInputs = [
    async attoparsec caseInsensitive cgi fgl GLUT GLURaw haskellSrc
    hashable html HTTP HUnit mtl network OpenGL OpenGLRaw parallel
    parsec QuickCheck random regexBase regexCompat regexPosix split stm
    syb text transformers unorderedContainers vector xhtml zlib
    cabalInstall alex happy primitive ghc
  ];
  unpackPhase = ''
    sourceRoot=haskell-platform
    mkdir $sourceRoot
    cp ${self.cabalFile} $sourceRoot/${self.pname}.cabal
    cp ${self.setupFile} $sourceRoot/Setup.hs
    touch $sourceRoot/LICENSE
  '';
  noHaddock = true;
  propagatedUserEnvPkgs = self.propagatedBuildInputs;
  meta = {
    homepage = "http://haskell.org/platform";
    description = "Haskell Platform meta package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [andres simons];
  };
})
