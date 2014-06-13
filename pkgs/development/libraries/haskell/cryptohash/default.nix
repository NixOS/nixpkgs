{ cabal, byteable, HUnit, QuickCheck, tasty, tastyHunit
, tastyQuickcheck
}:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.11.5";
  sha256 = "0vxnwnjch2r9d54q5f5bfz60npjc7s7x6a5233md7fa756822b9d";
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
