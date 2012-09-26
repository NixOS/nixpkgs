{ cabal, srcloc, text }:

cabal.mkDerivation (self: {
  pname = "mainland-pretty";
  version = "0.2.2";
  sha256 = "0kvn67g2ic46ybgyxpgpzjapwiww9848m9dv8y3xkkl7jd8anpb2";
  buildDepends = [ srcloc text ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Pretty printing designed for printing source code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
