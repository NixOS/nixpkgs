{cabal, zlib}:

cabal.mkDerivation (self : {
  pname = "zlib-bindings";
  version = "0.0.0";
  sha256 = "168sll6mrmcnvdmdx79izqxcrli1s7asp4qilhkqss8w0jlrv1ni";
  propagatedBuildInputs = [zlib];
  meta = {
    description = "Low-level bindings to the zlib package";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

