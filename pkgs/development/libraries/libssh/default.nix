{ stdenv, fetchurl, pkgconfig, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  name = "libssh-0.7.0";

  src = fetchurl {
    url = "https://git.libssh.org/projects/libssh.git/snapshot/${name}.tar.gz";
    sha256 = "1wfrdqhv97f4ycd9bcpgb6gw47kr7b2iq8cz5knk8a6n9c6870k0";
  };

  patches = [ ./0001-Reintroduce-ssh_forward_listen-Fixes-194.patch ];

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
