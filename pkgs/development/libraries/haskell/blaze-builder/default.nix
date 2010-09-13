{cabal, text}:

cabal.mkDerivation (self : {
  pname = "blaze-builder";
  version = "0.1";
  sha256 = "dc4c542a39cf9e82b6a7ca99d6f460d6fa8dc4c8f648224368eac3fe054127c5";
  propagatedBuildInputs = [text];
  meta = {
    description = "Builder to efficiently append text";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
