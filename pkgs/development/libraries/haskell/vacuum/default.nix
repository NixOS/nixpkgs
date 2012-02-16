{ cabal, Cabal, ghcPaths }:

cabal.mkDerivation (self: {
  pname = "vacuum";
  version = "1.0.0.2";
  sha256 = "1amlzd89952fvw1sbajf9kv3f2s2i6xbqs1zjxw442achg465y7i";
  buildDepends = [ Cabal ];
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
