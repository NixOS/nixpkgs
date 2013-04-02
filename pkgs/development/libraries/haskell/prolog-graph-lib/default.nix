{ cabal, fgl, graphviz, mtl, prolog, text }:

cabal.mkDerivation (self: {
  pname = "prolog-graph-lib";
  version = "0.2.0.1";
  sha256 = "02xa4hqmhmsv7vkdy3m3dr1w3z88kc8ly0jjn7q6pba5yarci7nr";
  buildDepends = [ fgl graphviz mtl prolog text ];
  meta = {
    homepage = "https://github.com/Erdwolf/prolog";
    description = "Generating images of resolution trees for Prolog queries";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
