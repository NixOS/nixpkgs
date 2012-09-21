{ cabal, mtl, systemFileio, systemFilepath, text, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "0.14.1";
  sha256 = "1cvfak5siysnpms1znra6dk762zp0gv1sam3xfdp67a7ir0hpcpp";
  buildDepends = [
    mtl systemFileio systemFilepath text time unixCompat
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/yesodweb/Shelly.hs";
    description = "shell-like (systems) programming in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
