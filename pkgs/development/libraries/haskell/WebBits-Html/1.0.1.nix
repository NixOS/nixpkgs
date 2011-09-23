{ cabal, mtl, parsec, syb, WebBits }:

cabal.mkDerivation (self: {
  pname = "WebBits-Html";
  version = "1.0.1";
  sha256 = "134rmm5ccfsjdr0pdwn2mf81l81rgxapa3wjjfjkxrkxq6hav35n";
  buildDepends = [ mtl parsec syb WebBits ];
  meta = {
    homepage = "http://www.cs.brown.edu/research/plt/";
    description = "JavaScript analysis tools";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
