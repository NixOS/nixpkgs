{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdargs";
  version = "0.7";
  sha256 = "0qijfdc66f0r2k272sl41nxfymmsk7naw5is3b4zyxsgm147c0vq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/cmdargs/";
    description = "Command line argument processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
