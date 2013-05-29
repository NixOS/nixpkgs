{ cabal, binary, blazeBuilder, Cabal, caseInsensitive, cmdargs
, conduit, filepath, haskellSrcExts, httpTypes, parsec, random
, safe, tagsoup, time, transformers, uniplate, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.16";
  sha256 = "1hamwqhndrkajm4xvxxfhr2rnlmf3z2ysyfxx3y6d24jawjyqf8a";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary blazeBuilder Cabal caseInsensitive cmdargs conduit filepath
    haskellSrcExts httpTypes parsec random safe tagsoup time
    transformers uniplate wai warp
  ];
  meta = {
    homepage = "http://www.haskell.org/hoogle/";
    description = "Haskell API Search";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
