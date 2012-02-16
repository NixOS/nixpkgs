{ cabal, Cabal, extensibleExceptions, hsemail, network }:

cabal.mkDerivation (self: {
  pname = "SMTPClient";
  version = "1.0.4";
  sha256 = "12m0qv8bf0s52yz07sipxlvas8k3xvi1d4lw6960q0nxr40ijyy2";
  buildDepends = [ Cabal extensibleExceptions hsemail network ];
  meta = {
    description = "A simple SMTP client library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
