{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, hspec
, hspecExpectations, httpTypes, HUnit, parsec, random, safe
, systemFileio, tagsoup, text, time, transformers, uniplate, wai
, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.23";
  sha256 = "1ykjf0w6c3pzsrzdhxs53nxj84aj2px3gpfc8f53dmgqv3wkyii7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson binary blazeBuilder Cabal caseInsensitive cmdargs conduit
    deepseq filepath haskellSrcExts httpTypes parsec random safe
    tagsoup text time transformers uniplate wai warp
  ];
  testDepends = [
    conduit hspec hspecExpectations HUnit systemFileio transformers
  ];
  meta = {
    homepage = "http://www.haskell.org/hoogle/";
    description = "Haskell API Search";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
