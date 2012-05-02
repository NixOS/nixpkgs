{ cabal, binary, blazeBuilder, Cabal, caseInsensitive, cmdargs
, conduit, filepath, haskellSrcExts, httpTypes, parsec, random
, safe, tagsoup, time, transformers, uniplate, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.11";
  sha256 = "0m708qlj3q8s9vywg51gj7bwwasz5nxqxqhqh8f0k96iawqd9gid";
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
