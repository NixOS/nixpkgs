{ lib, stdenv, fetchurl, openssl, zlib, windows }:

stdenv.mkDerivation rec {
  pname = "libssh2";
  version = "1.10.0";

  src = fetchurl {
    url = "https://www.libssh2.org/download/libssh2-${version}.tar.gz";
    sha256 = "sha256-LWTpDz3tOUuR06LndMogOkF59prr7gMAPlpvpiHkHVE=";
  };

  outputs = [ "out" "dev" "devdoc" ];

  buildInputs = [ openssl zlib ]
    ++ lib.optional stdenv.hostPlatform.isMinGW windows.mingw_w64;

  meta = with lib; {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = "https://www.libssh2.org";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
