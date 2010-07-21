{cabal, network, parsec, utf8String}:

cabal.mkDerivation (self : {
  pname = "web-routes";
  version = "0.22.0";
  sha256 = "6482ecba585cf7b1f32c29bfd5cb6f5e06dba72231e38ae5baa15b6b95f7c6c8";
  propagatedBuildInputs = [network parsec utf8String];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
