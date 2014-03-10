{ cabal, base64Bytestring, blazeBuilder, filepath, hspec, random
, text
}:

cabal.mkDerivation (self: {
  pname = "mime-mail";
  version = "0.4.4.1";
  sha256 = "0jzbkrd62alvgyx9bkrzicz88hjjnnavpv6hl22cxnirz41h8hw0";
  buildDepends = [
    base64Bytestring blazeBuilder filepath random text
  ];
  testDepends = [ blazeBuilder hspec text ];
  meta = {
    homepage = "http://github.com/snoyberg/mime-mail";
    description = "Compose MIME email messages";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
