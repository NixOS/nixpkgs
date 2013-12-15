{ cabal, base64Bytestring, blazeBuilder, filepath, hspec, random
, text
}:

cabal.mkDerivation (self: {
  pname = "mime-mail";
  version = "0.4.3";
  sha256 = "0xh6j4vdg2ispr9f41s8pvx5rb08zqapkqxyvykvjg2ibmczzg4f";
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
