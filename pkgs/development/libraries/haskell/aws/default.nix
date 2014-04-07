{ cabal, aeson, attempt, attoparsecConduit, base16Bytestring
, base64Bytestring, blazeBuilder, caseInsensitive, cereal, conduit
, cryptoApi, cryptohash, cryptohashCryptoapi, dataDefault, failure
, filepath, httpConduit, httpTypes, liftedBase, monadControl, mtl
, resourcet, text, time, transformers, unorderedContainers
, utf8String, vector, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "aws";
  version = "0.8.6";
  sha256 = "19hjwj15zmhmf33n2d2dkwan59ylwkaslh85sh04v05hsm8y5y1a";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attempt attoparsecConduit base16Bytestring base64Bytestring
    blazeBuilder caseInsensitive cereal conduit cryptoApi cryptohash
    cryptohashCryptoapi dataDefault failure filepath httpConduit
    httpTypes liftedBase monadControl mtl resourcet text time
    transformers unorderedContainers utf8String vector xmlConduit
  ];
  meta = {
    homepage = "http://github.com/aristidb/aws";
    description = "Amazon Web Services (AWS) for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
