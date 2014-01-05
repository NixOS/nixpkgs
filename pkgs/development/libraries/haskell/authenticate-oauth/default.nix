{ cabal, base64Bytestring, blazeBuilder, blazeBuilderConduit
, conduit, cryptoPubkeyTypes, dataDefault, httpConduit, httpTypes
, monadControl, random, resourcet, RSA, SHA, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "authenticate-oauth";
  version = "1.4.0.8";
  sha256 = "1mc36d6lkmqywzsxhzwv4445mmwdz0rr5ibd2a1nbgw5c5jw76fy";
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
