{ cabal, StateVar, transformers }:

cabal.mkDerivation (self: {
  pname = "Hipmunk";
  version = "5.2.0.3";
  sha256 = "1as00372hz0ngy6pc5l0w7qgw5flcyag07zk3dxkbj5kv24xk49m";
  buildDepends = [ StateVar transformers ];
  noHaddock = true;
  meta = {
    homepage = "http://patch-tag.com/r/felipe/hipmunk/home";
    description = "A Haskell binding for Chipmunk";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
