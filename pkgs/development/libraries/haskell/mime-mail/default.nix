{ cabal, base64Bytestring, blazeBuilder, random, text }:

cabal.mkDerivation (self: {
  pname = "mime-mail";
  version = "0.4.1.0";
  sha256 = "1czjxxpv2w8zvwm6nkv0rr47rdl84s5f5xvf3r4kjaw44a6jfgg0";
  buildDepends = [ base64Bytestring blazeBuilder random text ];
  meta = {
    homepage = "http://github.com/snoyberg/mime-mail";
    description = "Compose MIME email messages";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
