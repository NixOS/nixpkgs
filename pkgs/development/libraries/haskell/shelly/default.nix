{ cabal, hspec, HUnit, mtl, systemFileio, systemFilepath, text
, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "0.15.4.1";
  sha256 = "12m11s22izz0ny1syb1ykp2hi9n240myf0nhapvn8jx1fgf5iyck";
  buildDepends = [
    mtl systemFileio systemFilepath text time unixCompat
  ];
  testDepends = [
    hspec HUnit mtl systemFileio systemFilepath text time unixCompat
  ];
  meta = {
    homepage = "https://github.com/yesodweb/Shelly.hs";
    description = "shell-like (systems) programming in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
