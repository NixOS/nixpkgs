{ stdenv, fetchurl, fetchpatch, pkgconfig, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  name = "libssh-0.8.5";

  src = fetchurl {
    url = "https://www.libssh.org/files/0.8/${name}.tar.xz";
    sha256 = "0dd3nmd20jw4z116qbz3wbffxbzrczi6mcxw0rmqzj0g4hqw9lh7";
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
