{cabal, text}:

cabal.mkDerivation (self : {
  pname = "blaze-builder";
  version = "0.2.1.4";
  sha256 = "0r0lj2whwa1v99gx59l56af06w704qvv1vhkxlca86h7iri4b262";
  propagatedBuildInputs = [text];
  meta = {
    description = "Builder to efficiently append text";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
