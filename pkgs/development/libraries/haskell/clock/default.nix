{ cabal }:

cabal.mkDerivation (self: {
  pname = "clock";
  version = "0.4.0.1";
  sha256 = "1bn6dalank30l680iifyam0mg9izxbyscgq0vmr1aw5brba5kv6j";
  meta = {
    homepage = "http://corsis.github.com/clock/";
    description = "High-resolution clock functions: monotonic, realtime, cputime";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
