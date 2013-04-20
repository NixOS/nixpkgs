{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "time-compat";
  version = "0.1.0.3";
  sha256 = "0zqgzr8yjn36rn6gflwh5s0c92vl44xzxiw0jz8d5h0h8lhi21sr";
  buildDepends = [ time ];
  meta = {
    homepage = "http://hub.darcs.net/dag/time-compat";
    description = "Compatibility with old-time for the time package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
