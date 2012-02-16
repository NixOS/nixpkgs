{ cabal, mtl, parsec, syb }:

cabal.mkDerivation (self: {
  pname = "WebBits";
  version = "2.1";
  sha256 = "18m19fck9zb6jh8bfd47nja1q6ab1jmd0q5r3k8m5674i6273hyn";
  buildDepends = [ mtl parsec syb ];
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
