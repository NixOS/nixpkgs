{ cabal, base64Bytestring, blazeBuilder, blazeBuilderConduit
, conduit, cryptoPubkeyTypes, dataDefault, httpConduit, httpTypes
, monadControl, random, resourcet, RSA, SHA, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "authenticate-oauth";
  version = "1.4.0.7";
  sha256 = "1pmkj35rpbhgyjrfdg8j51xn9a420aawkwfg28fpxz7kid0cqw8g";
  buildDepends = [
    base64Bytestring blazeBuilder blazeBuilderConduit conduit
    cryptoPubkeyTypes dataDefault httpConduit httpTypes monadControl
    random resourcet RSA SHA time transformers
  ];
  meta = {
    homepage = "http://github.com/yesodweb/authenticate";
    description = "Library to authenticate with OAuth for Haskell web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
