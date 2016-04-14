{ stdenv, fetchurl, pkgconfig, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  name = "libssh-0.7.3";

  src = fetchurl {
    url = "https://red.libssh.org/attachments/download/195/${name}.tar.xz";
    sha256 = "165g49i4kmm3bfsjm0n8hm21kadv79g9yjqyq09138jxanz4dvr6";
  };

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  buildInputs = [ zlib openssl libsodium ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "SSH client library";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ sander urkud ];
    platforms = platforms.all;
  };
}
