{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, securemem, testFramework, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cipher-des";
  version = "0.0.4";
  sha256 = "18xpc7v0xyh0qb7p03ail1lyh376h1vg000xn22b5shpgp5kxiqq";
  buildDepends = [ byteable cryptoCipherTypes securemem ];
  testDepends = [
    byteable cryptoCipherTests cryptoCipherTypes QuickCheck
    testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "DES and 3DES primitives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
