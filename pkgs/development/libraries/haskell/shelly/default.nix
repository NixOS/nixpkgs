{ cabal, mtl, systemFileio, systemFilepath, text, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "1.4.1";
  sha256 = "04yi5kc9jfcpc1rq3prypc832xgv94lrzv3i8saf1rg8a6najwbx";
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
