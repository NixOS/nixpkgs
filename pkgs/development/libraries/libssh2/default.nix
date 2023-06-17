{ lib, stdenv, fetchurl, openssl, zlib, windows }:

stdenv.mkDerivation rec {
  pname = "libssh2";
  version = "1.10.0";

  src = fetchurl {
    url = "https://www.libssh2.org/download/libssh2-${version}.tar.gz";
    sha256 = "sha256-LWTpDz3tOUuR06LndMogOkF59prr7gMAPlpvpiHkHVE=";
  };

  outputs = [ "out" "dev" "devdoc" ];

  patches = [
    # https://github.com/libssh2/libssh2/pull/700
    # openssl: add support for LibreSSL 3.5.x
    ./openssl_add_support_for_libressl_3_5.patch
  ];

  buildInputs = [ openssl zlib ]
    ++ lib.optional stdenv.hostPlatform.isMinGW windows.mingw_w64;

  meta = with lib; {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = "https://www.libssh2.org";
    platforms = platforms.all;
    license = with licenses; [ bsd3 libssh2 ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
