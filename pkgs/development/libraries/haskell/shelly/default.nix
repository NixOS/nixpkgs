{ cabal, mtl, systemFileio, systemFilepath, text, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "0.14.2.1";
  sha256 = "0zddrb17i9aazwziazjzcb96n6m794qyj3h85whph06y4krbygnl";
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
