{ cabal, async, mtl, systemFileio, systemFilepath, text, time
, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "1.4.4.2";
  sha256 = "01h08bw7j7f5vi3bffd4ipvj5nmab8j5rqgxav688n2jm2342jzk";
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
