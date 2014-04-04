{ cabal, base64Bytestring, blazeBuilder, filepath, hspec, random
, sendmail ? "sendmail", text
}:

cabal.mkDerivation (self: {
  pname = "mime-mail";
  version = "0.4.5.1";
  sha256 = "01r6dxdp3183ahggda6dizdz1c3qpmpyxn6csalzvss52ds4ilsf";
  buildDepends = [
    base64Bytestring blazeBuilder filepath random text
  ];
  testDepends = [ blazeBuilder hspec text ];
  configureFlags = "--ghc-option=-DMIME_MAIL_SENDMAIL_PATH=\"${sendmail}\"";
  meta = {
    homepage = "http://github.com/snoyberg/mime-mail";
    description = "Compose MIME email messages";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
