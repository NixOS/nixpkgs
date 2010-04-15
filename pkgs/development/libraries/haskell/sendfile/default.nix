{cabal, network}:

cabal.mkDerivation (self : {
  pname = "sendfile";
  version = "0.6.1";
  sha256 = "c21b7f0f9a03a5e6d9b0691f5f0be9969d175f0514becdc199f0fd49097e51a2";
  propagatedBuildInputs = [network];
  meta = {
    description = "A portable sendfile library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

