{ cabal, base64Bytestring, blazeBuilder, filepath, hspec, random
, text, sendmail ? "sendmail"
}:

cabal.mkDerivation (self: {
  pname = "mime-mail";
  version = "0.4.4.2";
  sha256 = "0s38xgv6kycnfahqi5dnrjn3wkaq35w87cv8p12pq0qq2x7dvawd";
  buildDepends = [
    base64Bytestring blazeBuilder filepath random text
  ];
  testDepends = [ blazeBuilder hspec text ];
  configureFlags = [ "--ghc-option=-DMIME_MAIL_SENDMAIL_PATH=\"${sendmail}\"" ];
  meta = {
    homepage = "http://github.com/snoyberg/mime-mail";
    description = "Compose MIME email messages";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
