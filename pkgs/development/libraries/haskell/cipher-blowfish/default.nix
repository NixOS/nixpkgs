{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, securemem, testFramework, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "cipher-blowfish";
  version = "0.0.2";
  sha256 = "08jc1qsvnyk7zm7bp0nibkc6lx3bkid79cn1r6fidmccf716r3sp";
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
