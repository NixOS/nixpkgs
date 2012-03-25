{ cabal, binary, blazeBuilder, Cabal, caseInsensitive, cmdargs
, conduit, filepath, haskellSrcExts, httpTypes, parsec, random
, safe, tagsoup, time, transformers, uniplate, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.10";
  sha256 = "0vb4jj9m512v476fclmjzlk725hgba8q5njx2h1xwb0a76qvj2mg";
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
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
