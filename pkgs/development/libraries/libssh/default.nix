{ stdenv, fetchurl, pkgconfig, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  name = "libssh-0.7.5";

  src = fetchurl {
    url = "https://red.libssh.org/attachments/download/218/${name}.tar.xz";
    sha256 = "15bh6dm9c50ndddzh3gqcgw7axp3ghrspjpkb1z3dr90vkanvs2l";
  };

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  outputs = [ "out" "dev" ];

  buildInputs = [ zlib openssl libsodium ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "SSH client library";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
  };
}
