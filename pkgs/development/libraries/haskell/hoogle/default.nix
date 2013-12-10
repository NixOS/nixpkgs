{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, httpTypes
, parsec, random, safe, tagsoup, text, time, transformers, uniplate
, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.26";
  sha256 = "07nc58vqdj5x3h6d7z8ilbff0pkqd3r7g789xyaalnh6wjkd7380";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson binary blazeBuilder Cabal caseInsensitive cmdargs conduit
    deepseq filepath haskellSrcExts httpTypes parsec random safe
    tagsoup text time transformers uniplate wai warp
  ];
  testDepends = [ filepath ];
  doCheck = false;
  meta = {
    homepage = "http://www.haskell.org/hoogle/";
    description = "Haskell API Search";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
