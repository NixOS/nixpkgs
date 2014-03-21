{ cabal, async, mtl, systemFileio, systemFilepath, text, time
, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "1.5.0.1";
  sha256 = "19mfxdwnzv01bxd0l5q2z4mbdp7r8p6z2bm083vjlxx7cc35wv7a";
  buildDepends = [
    async mtl systemFileio systemFilepath text time unixCompat
  ];
  meta = {
    homepage = "https://github.com/yesodweb/Shelly.hs";
    description = "shell-like (systems) programming in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
