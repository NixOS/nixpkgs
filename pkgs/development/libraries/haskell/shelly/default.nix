{ cabal, mtl, systemFileio, systemFilepath, text, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "1.3.0.7";
  sha256 = "08ydsvgc8n0bvk5vcz3a3rpdbnranlbv8y84imkkh7i0p3nqyg2m";
  buildDepends = [
    mtl systemFileio systemFilepath text time unixCompat
  ];
  meta = {
    homepage = "https://github.com/yesodweb/Shelly.hs";
    description = "shell-like (systems) programming in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
