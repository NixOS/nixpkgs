{ cabal, srcloc, text }:

cabal.mkDerivation (self: {
  pname = "mainland-pretty";
  version = "0.2.4";
  sha256 = "0x481k36rz4zvj1nwvrfw1d10vbmmx8gb5f2nc8alnxcbc2y7xwq";
  buildDepends = [ srcloc text ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Pretty printing designed for printing source code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
