{ stdenv, fetchurl, pkgconfig, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  name = "libssh-0.7.2";

  src = fetchurl {
    url = "https://red.libssh.org/attachments/download/154/libssh-0.7.2.tar.xz";
    sha256 = "0v84zm957z31yyrj47n62hby38nrjk5ih0ajmgccnqrjdpwwrira";
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
