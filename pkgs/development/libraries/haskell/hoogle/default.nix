{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, hspec
, hspecExpectations, httpTypes, HUnit, parsec, random, safe
, systemFileio, tagsoup, text, time, transformers, uniplate, wai
, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.20";
  sha256 = "0sff230qc9lk3kqr9azg399fsaybwqpic9pj52jyw61ffasnl2dd";
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
  doCheck = false;
  meta = {
    homepage = "http://www.haskell.org/hoogle/";
    description = "Haskell API Search";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
