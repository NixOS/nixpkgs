{cabal, blazeBuilder, text}:

cabal.mkDerivation (self : {
  pname = "cookie";
  version = "0.2.1";
  sha256 = "0jn4as09qx2948k0r916vy5igz0xmrvng37s0il81b0ndvhnsc6c";
  propagatedBuildInputs = [blazeBuilder text];
  meta = {
    description = "HTTP cookie parsing and rendering";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

