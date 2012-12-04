{ cabal, parsec, ranges }:

cabal.mkDerivation (self: {
  pname = "email-validate";
  version = "0.3.2";
  sha256 = "0cshrl0if1ivn7c0ggm21r58pzsyp7l5wk3dgl86n6zla9dwdmhq";
  buildDepends = [ parsec ranges ];
  meta = {
    homepage = "http://porg.es/blog/email-address-validation-simpler-faster-more-correct";
    description = "Validating an email address string against RFC 5322";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
