{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "time-compat";
  version = "0.1.0.2";
  sha256 = "0687bxkvqs22p7skqb8n289k9nv7cafg8jyx32sswn2h11m7dihb";
  buildDepends = [ time ];
  meta = {
    homepage = "http://hub.darcs.net/dag/time-compat";
    description = "Compatibility with old-time for the time package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
