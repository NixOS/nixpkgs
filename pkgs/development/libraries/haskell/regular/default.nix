{cabal}:

cabal.mkDerivation (self : {
  pname = "regular";
  version = "0.3.2";
  sha256 = "104rz28a22p5pn3rdzvmh13s1hpr46n463cfaz3w3bj9cimi2rcj";
  meta = {
    description = "Generic programming library for regular datatypes";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

