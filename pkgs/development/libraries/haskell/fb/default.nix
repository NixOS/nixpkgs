{ cabal, aeson, attoparsec, base16Bytestring, base64Bytestring
, cereal, conduit, conduitExtra, cryptoApi, cryptohash
, cryptohashCryptoapi, dataDefault, hspec, httpConduit, httpTypes
, HUnit, liftedBase, monadControl, monadLogger, QuickCheck
, resourcet, text, time, transformers, transformersBase
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "fb";
  version = "1.0.2";
  sha256 = "1xgldk690dpbmhzmjlngpbalmbs0xrc7265zc7frphpsbbw3cnqc";
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
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/prowdsponsor/fb";
    description = "Bindings to Facebook's API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
