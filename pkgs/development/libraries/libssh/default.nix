{ stdenv, fetchurl, pkgconfig, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  pname = "libssh";
  version = "0.8.8";

  src = fetchurl {
    url = "https://www.libssh.org/files/0.8/${pname}-${version}.tar.xz";
    sha256 = "1qk5bm9r6199jbfk54f8w24vkl52051g8s3kmq4z2kdc6vbpy4jb";
  };

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  # single output, otherwise cmake and .pc files point to the wrong directory
  # outputs = [ "out" "dev" ];

  buildInputs = [ zlib openssl libsodium ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "SSH client library";
    homepage = "https://libssh.org";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
  };
}
