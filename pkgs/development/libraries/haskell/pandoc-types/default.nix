{ cabal, aeson, syb }:

cabal.mkDerivation (self: {
  pname = "pandoc-types";
  version = "1.12.1";
  sha256 = "0gqn7byag5vx09mwbx6y3zs3hqmncarlpml0cfc5picwv8kg4vbj";
  buildDepends = [ aeson syb ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Types for representing a structured document";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
