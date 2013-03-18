{ cabal, base64Bytestring, blazeBuilder, blazeBuilderConduit
, conduit, cryptoPubkeyTypes, dataDefault, httpConduit, httpTypes
, monadControl, random, resourcet, RSA, SHA, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "authenticate-oauth";
  version = "1.4.0.5";
  sha256 = "0yic95glkc0j35sdq04z5n2607ch0k64vyi3y0kfji31qzd3d44x";
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
