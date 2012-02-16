{ cabal, Cabal, mtl, parsec, syb }:

cabal.mkDerivation (self: {
  pname = "WebBits";
  version = "1.0";
  sha256 = "1xqk4ajywlaq9nb9a02i7c25na5p2qbpc2k9zw93gbapppjiapsc";
  buildDepends = [ Cabal mtl parsec syb ];
  meta = {
    homepage = "http://www.cs.brown.edu/research/plt/";
    description = "JavaScript analysis tools";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
