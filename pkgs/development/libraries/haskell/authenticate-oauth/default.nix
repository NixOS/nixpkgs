{ cabal, base64Bytestring, blazeBuilder, blazeBuilderConduit
, conduit, cryptoPubkeyTypes, dataDefault, httpConduit, httpTypes
, monadControl, random, resourcet, RSA, SHA, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "authenticate-oauth";
  version = "1.4.0.6";
  sha256 = "1ylfvc744wqyn5xbv6fivfys5kk9k9r2b9xf63zfzj5l5yqmv91a";
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
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
