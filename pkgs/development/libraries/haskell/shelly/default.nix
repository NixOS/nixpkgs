{ cabal, mtl, systemFileio, systemFilepath, text, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "0.14.2";
  sha256 = "1vx7yq5fj4dnba94ypf8ldd236kivxisrzhkxcfhhar5zvw2jqng";
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
