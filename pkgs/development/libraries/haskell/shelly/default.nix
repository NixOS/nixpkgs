{ cabal, mtl, systemFileio, systemFilepath, text, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "0.14.0.1";
  sha256 = "062c3zqr6ad61p0s423h8rhimqfld6p95z3qzrmag9f29a5f4fbz";
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
