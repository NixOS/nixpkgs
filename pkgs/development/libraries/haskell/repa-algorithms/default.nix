{cabal, repa, vector}:

cabal.mkDerivation (self : {
  pname = "repa-algorithms";
  version = "2.0.0.3";
  sha256 = "17h5xbn8gy0glryrv7pjdpxaw9adrk0bln683p0xxl6wrx90ngdv";
  propagatedBuildInputs = [repa vector];
  meta = {
    description = "Algorithms using the Repa array library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

