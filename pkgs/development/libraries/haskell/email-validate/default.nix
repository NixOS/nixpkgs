{ cabal, parsec, ranges }:

cabal.mkDerivation (self: {
  pname = "email-validate";
  version = "0.2.8";
  sha256 = "04cz1nm1zkb46kdxs43pmkxli2xm5nqlh951nn0mdgy6hqhkpkqd";
  buildDepends = [ parsec ranges ];
  meta = {
    homepage = "http://porg.es/blog/email-address-validation-simpler-faster-more-correct";
    description = "Validating an email address string against RFC 5322";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
