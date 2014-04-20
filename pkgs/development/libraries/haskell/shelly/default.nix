{ cabal, async, mtl, systemFileio, systemFilepath, text, time
, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "1.5.2";
  sha256 = "1iyn3xxmqbrx6xfay364m2qgflscmz9crr051jpzg0b629b8wssa";
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
