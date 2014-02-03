{ cabal, async, mtl, systemFileio, systemFilepath, text, time
, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "1.4.4";
  sha256 = "0gxmwwpg7p5ai35ng8fsx743w3q9p5jl0c1c3ckiqvz4jbwgyf7y";
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
