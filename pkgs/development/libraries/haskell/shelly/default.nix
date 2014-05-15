{ cabal, async, enclosedExceptions, exceptions, liftedAsync
, liftedBase, monadControl, mtl, systemFileio, systemFilepath, text
, time, transformers, transformersBase, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "1.5.3.1";
  sha256 = "0lhan549nkxihd94byaknswczlr757smha2fwq7y82rr0k16im4y";
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
