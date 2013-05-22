{ cabal, mtl, parsec, syb }:

cabal.mkDerivation (self: {
  pname = "WebBits";
  version = "2.0";
  sha256 = "14a1rqlq925f6rdbi8yx44xszj5pvskcmw1gi1bj8hbilgmlwi7f";
  buildDepends = [ mtl parsec syb ];
  meta = {
    homepage = "http://www.cs.brown.edu/research/plt/";
    description = "JavaScript analysis tools";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
