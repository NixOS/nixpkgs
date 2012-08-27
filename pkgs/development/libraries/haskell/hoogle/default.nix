{ cabal, binary, blazeBuilder, Cabal, caseInsensitive, cmdargs
, conduit, filepath, haskellSrcExts, httpTypes, parsec, random
, safe, tagsoup, time, transformers, uniplate, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.13";
  sha256 = "0asw9lr22d8jxr58b7w2j5hgllxhw2w8kllh5aq5jjs272hjiy9i";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
