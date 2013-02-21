{ cabal, attoparsec }:

cabal.mkDerivation (self: {
  pname = "email-validate";
  version = "1.0.0";
  sha256 = "0sj1cvn9ap0m8d4cg4cqavvmkd74vp86lyyra9g6f17815sxdbsg";
  buildDepends = [ attoparsec ];
  meta = {
    homepage = "http://porg.es/blog/email-address-validation-simpler-faster-more-correct";
    description = "Validating an email address string against RFC 5322";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
