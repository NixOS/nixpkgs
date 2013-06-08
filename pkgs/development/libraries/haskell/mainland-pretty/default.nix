{ cabal, srcloc, text }:

cabal.mkDerivation (self: {
  pname = "mainland-pretty";
  version = "0.2.6";
  sha256 = "1mjw79jg0vq8qvgvjdinidw1pvfj3mych3z0f6g031vmqz7fqvzy";
  buildDepends = [ srcloc text ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Pretty printing designed for printing source code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
