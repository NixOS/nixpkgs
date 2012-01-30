{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdargs";
  version = "0.9.2";
  sha256 = "1c0xy4g9b5jqy51qhgq7djafqz27z6q7ya31pgy186pfgl7604kr";
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
