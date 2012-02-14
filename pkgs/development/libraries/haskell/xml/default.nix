{ cabal, Cabal, text }:

cabal.mkDerivation (self: {
  pname = "xml";
  version = "1.3.12";
  sha256 = "1lmqnzna0zy297y4q6qviv7a4966zz9mhfhk6anrp66cz890whai";
  buildDepends = [ Cabal text ];
  meta = {
    homepage = "http://code.galois.com";
    description = "A simple XML library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
