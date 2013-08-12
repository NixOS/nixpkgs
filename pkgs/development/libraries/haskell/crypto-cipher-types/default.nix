{ cabal, byteable, HUnit, mtl, QuickCheck, securemem, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-cipher-types";
  version = "0.0.1";
  sha256 = "0brwb6awni3jm152vi68saz6gla7kgwf2pfjalzqsi8qjpjbzgpj";
  buildDepends = [ byteable securemem ];
  testDepends = [
    byteable HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Generic cryptography cipher types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
