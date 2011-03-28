{cabal}:

cabal.mkDerivation (self : {
  pname = "erf";
  version = "1.0.0.0";
  sha256 = "0zkb9csnfqcrzdkqqn0xihfx1k17fw9ki7y3d1di67lnlmjpkqnn";
  meta = {
    description = "The error function, erf, and friends";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

