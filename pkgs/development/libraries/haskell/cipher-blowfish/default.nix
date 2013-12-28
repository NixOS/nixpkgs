{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, securemem, testFramework, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "cipher-blowfish";
  version = "0.0.3";
  sha256 = "0hb67gmiyqrknynz5am8nada1b1v47rqla87dw5nvfhxhl51fhcg";
  buildDepends = [ byteable cryptoCipherTypes securemem vector ];
  testDepends = [
    byteable cryptoCipherTests cryptoCipherTypes QuickCheck
    testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Blowfish cipher";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
