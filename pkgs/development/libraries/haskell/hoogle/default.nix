{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, httpTypes
, parsec, QuickCheck, random, resourcet, safe, shake, tagsoup, text
, time, transformers, uniplate, vector, vectorAlgorithms, wai, warp
, fetchurl
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.32";
  sha256 = "1rhr7xh4x9fgflcszbsl176r8jq6rm81bwzmbz73f3pa1zf1v0zc";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson binary blazeBuilder Cabal caseInsensitive cmdargs conduit
    deepseq filepath haskellSrcExts httpTypes parsec QuickCheck random
    resourcet safe shake tagsoup text time transformers uniplate vector
    vectorAlgorithms wai warp
  ];
  testDepends = [ filepath ];
  testTarget = "--test-option=--no-net";
  patches = [ (fetchurl { url = "https://github.com/ndmitchell/hoogle/commit/5fc294f2b5412fda107c7700f4d833b52f26184c.diff";
                          sha256 = "1fn52g90p2jsy87gf5rqrcg49s8hfwway5hi4v9i2rpg5mzxaq3i"; })
            ];
  meta = {
    homepage = "http://www.haskell.org/hoogle/";
    description = "Haskell API Search";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
