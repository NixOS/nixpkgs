{ cabal, mtl, systemFileio, systemFilepath, text, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "0.12.0.2";
  sha256 = "0gyjmwrp1n7xrjc8rn4qgnrssfikrgp4as10a9kydjnllyfaj38z";
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
