{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "utility-ht";
  version = "0.0.10";
  sha256 = "17ydzb0p8xhddvfvm4wjv5yjmy0v7nj6fsj11srnnpj91wc9k0xd";
  testDepends = [ QuickCheck ];
  meta = {
    description = "Various small helper functions for Lists, Maybes, Tuples, Functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
