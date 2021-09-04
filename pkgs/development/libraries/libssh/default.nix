{ lib, stdenv, fetchurl, pkg-config, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  pname = "libssh";
  version = "0.9.6";

  src = fetchurl {
    url = "https://www.libssh.org/files/0.9/${pname}-${version}.tar.xz";
    sha256 = "16w2mc7pyv9mijjlgacbz8dgczc7ig2m6m70w1pld04vpn2zig46";
  };

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  # single output, otherwise cmake and .pc files point to the wrong directory
  # outputs = [ "out" "dev" ];

  buildInputs = [ zlib openssl libsodium ];

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "SSH client library";
    homepage = "https://libssh.org";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
  };
}
