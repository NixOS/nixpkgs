{ cabal, aeson, attoparsec, attoparsecConduit, base16Bytestring
, base64Bytestring, cereal, conduit, cryptoApi, cryptohash
, cryptohashCryptoapi, dataDefault, hspec, httpConduit, httpTypes
, HUnit, liftedBase, monadControl, monadLogger, QuickCheck
, resourcet, text, time, transformers, transformersBase
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "fb";
  version = "0.15.2";
  sha256 = "1nkgw4978kwhqs7h6rlsspx2f9dbmsywjn57v2fg1c1lg271rz1d";
  buildDepends = [
    aeson attoparsec attoparsecConduit base16Bytestring
    base64Bytestring cereal conduit cryptoApi cryptohash
    cryptohashCryptoapi dataDefault httpConduit httpTypes liftedBase
    monadControl monadLogger resourcet text time transformers
    transformersBase unorderedContainers
  ];
  testDepends = [
    aeson conduit dataDefault hspec httpConduit HUnit liftedBase
    monadControl QuickCheck text time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/meteficha/fb";
    description = "Bindings to Facebook's API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
