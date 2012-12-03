{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "time-compat";
  version = "0.1.0.1";
  sha256 = "1fh5ylxv9cmgirakimizfdili3xf3ggqhhz5hz3v9i13mh4bgzvd";
  buildDepends = [ time ];
  meta = {
    homepage = "http://hub.darcs.net/dag/time-compat";
    description = "Compatibility with old-time for the time package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
