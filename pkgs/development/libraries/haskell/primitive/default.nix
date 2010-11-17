{cabal}:

cabal.mkDerivation (self : {
  pname = "primitive";
  version = "0.3.1";
  sha256 = "1903hx88ax4dgyyx00a0k86jy4mkqrprpn7arfy19dqqyfpb2ikj";
  meta = {
    description = "Wrappers for primitive operations";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

