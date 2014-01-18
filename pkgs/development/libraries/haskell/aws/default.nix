{ cabal, attempt, base64Bytestring, blazeBuilder, caseInsensitive
, cereal, conduit, cryptoApi, cryptohash, cryptohashCryptoapi
, dataDefault, failure, filepath, httpConduit, httpTypes
, liftedBase, monadControl, mtl, resourcet, text, time
, transformers, utf8String, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "aws";
  version = "0.8.4";
  sha256 = "0p4m07lw33wd82phwfvyr1alqx3bsafnf25n60h1mss7l0rzyn0i";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attempt base64Bytestring blazeBuilder caseInsensitive cereal
    conduit cryptoApi cryptohash cryptohashCryptoapi dataDefault
    failure filepath httpConduit httpTypes liftedBase monadControl mtl
    resourcet text time transformers utf8String xmlConduit
  ];
  meta = {
    homepage = "http://github.com/aristidb/aws";
    description = "Amazon Web Services (AWS) for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
