{ cabal, byteable, HUnit, QuickCheck, tasty, tastyHunit
, tastyQuickcheck
}:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.11.6";
  sha256 = "0dyzcaxr8vhzqq9hj4240rxpi87h4ps87yz09klz723shls26f6s";
  buildDepends = [ byteable ];
  testDepends = [
    byteable HUnit QuickCheck tasty tastyHunit tastyQuickcheck
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash";
    description = "collection of crypto hashes, fast, pure and practical";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
