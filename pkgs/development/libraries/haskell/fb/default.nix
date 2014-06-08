{ cabal, aeson, attoparsec, base16Bytestring, base64Bytestring
, cereal, conduit, conduitExtra, cryptoApi, cryptohash
, cryptohashCryptoapi, dataDefault, hspec, httpConduit, httpTypes
, HUnit, liftedBase, monadControl, monadLogger, QuickCheck
, resourcet, text, time, transformers, transformersBase
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "fb";
  version = "1.0.1";
  sha256 = "0xhwv8fmhb1an15fnfjxzq0ijnhxxmfjwzd99dq1lsm0f7gd4hfi";
  buildDepends = [
    aeson attoparsec base16Bytestring base64Bytestring cereal conduit
    conduitExtra cryptoApi cryptohash cryptohashCryptoapi dataDefault
    httpConduit httpTypes liftedBase monadControl monadLogger resourcet
    text time transformers transformersBase unorderedContainers
  ];
  testDepends = [
    aeson conduit dataDefault hspec httpConduit HUnit liftedBase
    monadControl QuickCheck resourcet text time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/meteficha/fb";
    description = "Bindings to Facebook's API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
