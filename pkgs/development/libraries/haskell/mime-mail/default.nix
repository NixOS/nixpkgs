{ cabal, base64Bytestring, blazeBuilder, filepath, hspec, random
, text
}:

cabal.mkDerivation (self: {
  pname = "mime-mail";
  version = "0.4.2.1";
  sha256 = "1rpxx90k4dgz1b5ss6vqqgd9n1hjrv09q20myy16zzlj1gmn8k3g";
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
