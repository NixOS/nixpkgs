{ cabal, base16Bytestring, base64Bytestring, cryptohash, filepath
, mimeMail, network, text
}:

cabal.mkDerivation (self: {
  pname = "smtp-mail";
  version = "0.1.4.3";
  sha256 = "0kpm42n7s3rvkn9i3s8wvkdrq2d85qy422y6p2r4s7nivh6sx1dk";
  buildDepends = [
    base16Bytestring base64Bytestring cryptohash filepath mimeMail
    network text
  ];
  meta = {
    homepage = "http://github.com/jhickner/smtp-mail";
    description = "Simple email sending via SMTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
