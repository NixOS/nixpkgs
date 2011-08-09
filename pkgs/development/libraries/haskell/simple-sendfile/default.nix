{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "simple-sendfile";
  version = "0.1.2";
  sha256 = "08w5ria2x41j85z1126kddi918zdqrwmr4vwqczgzh9kdi49wv8j";
  buildDepends = [ network ];
  meta = {
    description = "Cross platform library for the sendfile system call";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
