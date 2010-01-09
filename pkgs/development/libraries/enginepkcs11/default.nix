{stdenv, fetchurl, libp11, pkgconfig, openssl}:

stdenv.mkDerivation rec {
  name = "engine_pkcs11-0.1.8";
  
  src = fetchurl {
    url = "http://www.opensc-project.org/files/engine_pkcs11/${name}.tar.gz";
    sha256 = "1rd20rxy12rfx3kwwvk5sqvc1ll87z60rqak1ksfwbf4wx0pwzfy";
  };
  
  buildInputs = [ libp11 pkgconfig openssl ];

  meta = {
    homepage = http://www.opensc-project.org/engine_pkcs11/;
    license = "BSD";
    description = "Engine for OpenSSL to use smart cards in PKCS#11 format";
  };
}
