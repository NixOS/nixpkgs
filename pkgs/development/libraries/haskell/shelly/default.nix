{ cabal, async, enclosedExceptions, exceptions, liftedAsync
, liftedBase, monadControl, mtl, systemFileio, systemFilepath, text
, time, transformers, transformersBase, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "shelly";
  version = "1.5.4";
  sha256 = "1jxw3c25n7azvfyj9vark9149sk36d01pfij6lgamhjs28mb860d";
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
