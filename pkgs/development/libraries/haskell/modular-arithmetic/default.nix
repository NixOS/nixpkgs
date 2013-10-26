{ cabal }:

cabal.mkDerivation (self: {
  pname = "modular-arithmetic";
  version = "1.0.1.1";
  sha256 = "14n83kjmz8mqjivjhwxk1zckms5z3gn77yq2hsw2yybzff2vkdkd";
  meta = {
    description = "A type for integers modulo some constant";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
