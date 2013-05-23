{ cabal, binary, executablePath, filepath, ghcPaths, ioStorage
, time, xdgBasedir
}:

cabal.mkDerivation (self: {
  pname = "dyre";
  version = "0.8.11";
  sha256 = "0sg5csshznbbyvq72s4sps7bkjlkfxiwcy4i3ip83lrxjw1msvr8";
  buildDepends = [
    binary executablePath filepath ghcPaths ioStorage time xdgBasedir
  ];
  meta = {
    homepage = "http://github.com/willdonnelly/dyre";
    description = "Dynamic reconfiguration in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
