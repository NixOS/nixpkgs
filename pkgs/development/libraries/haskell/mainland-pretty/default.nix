{ cabal, srcloc, text }:

cabal.mkDerivation (self: {
  pname = "mainland-pretty";
  version = "0.2.5";
  sha256 = "0h3q7xw69dc0lcqwlacsnv36dlbj0sfgv5imjlqrixy6m5cniq9x";
  buildDepends = [ srcloc text ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Pretty printing designed for printing source code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
