{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, securemem, testFramework, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "cipher-camellia";
  version = "0.0.2";
  sha256 = "19z2mi1rvp8fsqjdbmrm1hdlxmx61yr55fyknmmn945qrlvx234d";
  buildDepends = [ byteable cryptoCipherTypes securemem vector ];
  testDepends = [
    byteable cryptoCipherTests cryptoCipherTypes QuickCheck
    testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Camellia block cipher primitives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
