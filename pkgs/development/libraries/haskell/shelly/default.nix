{ cabal, async, mtl, systemFileio, systemFilepath, text, time
, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "1.4.3.1";
  sha256 = "04q22wprp0x075xyx6lnr8r792izvfigi4zryz2lxr5kqnzjki6r";
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
