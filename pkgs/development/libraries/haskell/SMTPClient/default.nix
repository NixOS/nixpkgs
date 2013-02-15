{ cabal, extensibleExceptions, hsemail, network }:

cabal.mkDerivation (self: {
  pname = "SMTPClient";
  version = "1.1.0";
  sha256 = "07njj24c43iz33c641d5ish62h13lhpvn2mx5pv5i6s3fm3bxsfk";
  buildDepends = [ extensibleExceptions hsemail network ];
  meta = {
    description = "A simple SMTP client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
