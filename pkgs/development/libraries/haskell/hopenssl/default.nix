{ cabal, mtl, openssl }:

cabal.mkDerivation (self: {
  pname = "hopenssl";
  version = "1.6.1";
  sha256 = "75ba42c5e9b02c09057c5aa25f577bdfe5214533fbd2921ac555897ade85958a";
  buildDepends = [ mtl ];
  extraLibraries = [ openssl ];
  meta = {
    homepage = "http://gitorious.org/hopenssl";
    description = "FFI bindings to OpenSSL's EVP digest interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
