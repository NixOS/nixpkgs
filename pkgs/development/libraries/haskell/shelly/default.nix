{ cabal, async, enclosedExceptions, exceptions, liftedAsync
, liftedBase, monadControl, mtl, systemFileio, systemFilepath, text
, time, transformers, transformersBase, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "1.5.3.2";
  sha256 = "0ilqg7mffw8cnl3w175if74xwfij7460qqqsp6hzml7gzjdb0rky";
  buildDepends = [
    async enclosedExceptions exceptions liftedAsync liftedBase
    monadControl mtl systemFileio systemFilepath text time transformers
    transformersBase unixCompat
  ];
  meta = {
    homepage = "https://github.com/yesodweb/Shelly.hs";
    description = "shell-like (systems) programming in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
