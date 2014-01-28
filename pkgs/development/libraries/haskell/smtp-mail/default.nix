{ cabal, base16Bytestring, base64Bytestring, cryptohash, filepath
, mimeMail, network, text
}:

cabal.mkDerivation (self: {
  pname = "smtp-mail";
  version = "0.1.4.4";
  sha256 = "055b736sr9w4dxf1p5xjfsisqxk49kz4d3hyqwgdvi8zzvi31vp6";
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
