{ cabal, network }:

cabal.mkDerivation (self: {
  pname = "simple-sendfile";
  version = "0.2.5";
  sha256 = "1g9plryh86lc03rf1s8m36wyc2yqp4y6f02viq9c4g1k85rkbs53";
  buildDepends = [ network ];
  meta = {
    description = "Cross platform library for the sendfile system call";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
