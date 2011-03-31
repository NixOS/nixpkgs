{cabal, mtl, openssl}:

cabal.mkDerivation (self : {
  pname = "hopenssl";
  version = "1.6.1";
  sha256 = "12lmhpg7m2amqld95lpv6d2j3rfzgdbmz8jsgh2hjb5hx72l5fkm";
  propagatedBuildInputs = [mtl];
  extraBuildInputs = [openssl];
  meta = {
    description = "FFI bindings to OpenSSL's EVP digest interface";
    license = "BSD3";
  };
})

