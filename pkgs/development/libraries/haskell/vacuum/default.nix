{ cabal, ghcPaths }:

cabal.mkDerivation (self: {
  pname = "vacuum";
  version = "1.0.0.1";
  sha256 = "172py7nvyv66hvqmhigfm59rjb328bfzv0z11q8qdpf5w1fpvmc5";
  extraLibraries = [ ghcPaths ];
  meta = {
    homepage = "http://web.archive.org/web/20100410115820/http://moonpatio.com/vacuum/";
    description = "Extract graph representations of ghc heap values";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
