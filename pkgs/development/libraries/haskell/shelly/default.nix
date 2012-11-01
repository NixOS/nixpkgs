{ cabal, mtl, systemFileio, systemFilepath, text, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "0.14.2.2";
  sha256 = "10wnmbs8bfj5m7z8gxj4z5ncvrx55br4mcfgs9x2w1avjzq5yhq3";
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
