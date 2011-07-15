{cabal, text}:

cabal.mkDerivation (self : {
  pname = "blaze-builder";
  version = "0.3.0.1";
  sha256 = "1p3xlifcr7v987zx8l2sppn9yydph332mn1xxk0yfi78a6386nfb";
  propagatedBuildInputs = [text];
  meta = {
    description = "Builder to efficiently append text";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
