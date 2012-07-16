{ cabal, binary, blazeBuilder, Cabal, caseInsensitive, cmdargs
, conduit, filepath, haskellSrcExts, httpTypes, parsec, random
, safe, tagsoup, time, transformers, uniplate, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.12";
  sha256 = "1j726bm8sx4qamaib6l14s4a4jz4z6szhj1vk8n5b6f3g38s7hwy";
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
