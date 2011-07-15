{cabal, ansiTerminal, ansiWLPprint, hostname, regexPosix, xml}:

cabal.mkDerivation (self : {
  pname = "test-framework";
  version = "0.4.0";
  sha256 = "0zxrdndycr63kzfibk0c2n4j39x6b8s4332sgqm54g1vdl3fxzbl";
  propagatedBuildInputs = [ansiTerminal ansiWLPprint hostname regexPosix xml];
  meta = {
    description = "Framework for running and organising tests";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

