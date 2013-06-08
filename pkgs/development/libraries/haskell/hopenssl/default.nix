{ cabal, mtl, openssl }:

cabal.mkDerivation (self: {
  pname = "hopenssl";
  version = "1.6.2";
  sha256 = "0b9xdm7jgkadx53vwszjnisyblzsqk99s3zqppgp0iqqf9955s4w";
  buildDepends = [ mtl ];
  extraLibraries = [ openssl ];
  meta = {
    homepage = "http://github.com/peti/hopenssl";
    description = "FFI bindings to OpenSSL's EVP digest interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
